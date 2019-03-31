<?php
namespace cntrl;

use model\config;
use Tuupola\Middleware\HttpBasicAuthentication;
use Slim\Views\TwigExtension;
use Slim\Views\Twig;
use Slim\Http\Request;
use Slim\Http\Response;
use PHPMailer\PHPMailer\PHPMailer;
use model\realms;
use Illuminate\Database\Eloquent\Model;
use model\path_realm;
use model\users;
use model\permissions;
use model\subdirectory;
use Slim;
use Illuminate\Support\Facades\Schema;
use Slim\Container;
use model\sm_pages;

/**
 * wrapper class for defining core modules environment
 *
 * @author Ivan Podlipnyak podlipnyak@econ.vsu.ru
 * @property $app Slim\App
 * @property $render_data array with data params for page template
 *          
 *          
 */
class master
{

    public $app;

    public $render_data;

    protected $template_folder = __DIR__ . '/../view/templates';

    protected $cache_folder = __DIR__ . '/../view/cache';

    function __construct()
    {
        $this->app = new \Slim\App();

        $this->template_engine_init();
        $this->mailer_init();
        $this->auth_init();
        $this->router_init();
        $this->restapi_init();

        $this->test_routes();
    }

    protected function test_routes()
    {
        /* test get request */
        $this->app->get('/test/{id}', function (Request $request, Response $response, $args) {
            $data = master::get_config();
            $data['test-id'] = $args['id'];
            $data = config::all();
            $data = [];
            foreach (config::all() as $config) {
                $data[$config->config_key] = $config->config_value;
            }

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        // Render Twig template in route
        $this->app->get('/hello/{name}', function (Request $request, Response $response, $args) {
            return $this->view->render($response, 'test.twig', [
                'name' => $args['name'],
                'title' => 'whats up'
            ]);
        });
    }

    protected function router_init()
    {
        $sub_list = subdirectory::all();

        foreach ($sub_list as $sub) {
            if ($sub->page_template) {
                $args_suffix = '[/{id}]';
            } else {
                $args_suffix = '[/]';
            }

            $this->app->get($sub->sub_url . $args_suffix, function (Request $request, Response $response, $args) use ($sub) {
                /* @var $this Container */
                if ($sub->sub_redirect_code && $sub->sub_redirect_path) {
                    return $response->withStatus((int) $sub->sub_redirect_code)
                        ->withHeader('Location', $sub->sub_redirect_path);
                } else {
                    /* if sub have a specified page template we will show it when args would be provided */
                    if ($args['id']) {
                        $template = $sub->page_template;
                    } else {
                        $template = $sub->sub_template;
                    }

                    $render_data = [
                        'theme' => $sub->theme_template,
                        'title' => $sub->sub_name,
                        'login' => $_SERVER['PHP_AUTH_USER']
                    ];

                    /* nav menu for dashboard */
                    $nav_menu = [];
                    $first_lvl_sub_list = subdirectory::where('hidden', 0)->where('parent_sub_id', 1)
                        ->get();
                    foreach ($first_lvl_sub_list as $first_lvl_sub) {

                        $nav_link = [
                            'class' => $first_lvl_sub->sub_id == $sub->sub_id ? 'active' : '',
                            'name' => $first_lvl_sub->sub_name,
                            'url' => $first_lvl_sub->sub_url
                        ];

                        if (subdirectory::where('hidden', 0)->where('parent_sub_id', $first_lvl_sub->sub_id)
                            ->count() > 0) {
                            $nav_link['class'] .= ' treeview';
                            $nav_link['nested_ul'] = [];
                            $second_lvl_sub_list = subdirectory::where('hidden', 0)->where('parent_sub_id', $first_lvl_sub->sub_id)
                                ->get();
                            foreach ($second_lvl_sub_list as $second_lvl_sub) {
                                $nested_li = [
                                    'name' => $second_lvl_sub->sub_name,
                                    'url' => $second_lvl_sub->sub_url
                                ];

                                if ($second_lvl_sub->sub_id == $sub->sub_id) {
                                    $nav_link['class'] .= ' active menu-open';
                                    $nested_li['class'] = 'active';
                                }

                                array_push($nav_link['nested_ul'], $nested_li);
                            }
                        }
                        array_push($nav_menu, $nav_link);
                    }
                    $render_data['menu_links'] = $nav_menu;

                    /* For every sub possible to create a controller wich can modify render data for twig template */
                    /* @var $sub_controller sub_controller */
                    $sub_type = $sub->data_controller;
                    if ($sub_type) {
                        $sub_type = "cntrl\\" . $sub_type;
                        $sub_controller = new $sub_type($this, $sub, $render_data, $args);
                        $render_data = $sub_controller->get_render_data();
                    }

                    return $this->view->render($response, $template, $render_data);
                }
            });
        }
    }

    protected function restapi_init()
    {
        $this->app->post('/api/sm_new_page', function (Request $request, Response $response, array $args) {
            $page_data = $request->getParsedBody();
            $page_model = new sm_pages();

            foreach ($page_data as $key => $value) {
                $page_model->$key = $value;
            }

            $page_model->save();

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($page_model->page_id));
        });

        $this->app->post('/api/sm_page', function (Request $request, Response $response, array $args) {
            $page_data = $request->getParsedBody();
            $page_model = sm_pages::find($page_data['page_id']);

            unset($page_data['create_time']);
            unset($page_data['update_time']);
            unset($page_data['last_check_time']);
            unset($page_data['page_id']);
            unset($page_data['status']);

            foreach ($page_data as $key => $value) {
                $page_model->$key = $value;
            }

            $page_model->save();
        });

        $this->app->delete('/api/sm_pages', function (Request $request, Response $response, array $args) {
            $pages_on_delete = $request->getParsedBody()['pages_on_delete'];

            $data = sm_pages::whereIn('page_id', $pages_on_delete)->delete();

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->get('/api/sm_list[/{domain}/{sort_by}/{order}]', function (Request $request, Response $response, array $args) {
            if ($args['domain']) {
                $data = sm_pages::where('domain', '=', $args['domain'])->orderBy($args['sort_by'], $args['order'])
                    ->get()
                    ->toArray();
                foreach ($data as $key => $page) {
                    $status_assoc = [
                        1 => 'success',
                        2 => 'success',
                        3 => 'redirect',
                        4 => 'error',
                        5 => 'error'
                    ];
                    $data[$key]['status'] = $status_assoc[(int) substr($page['http_status_code'], 0, 1)];
                    // $data[$key]['status'] = (int)substr($page['http_status_code'], 0, 1);
                }
            } else {
                $data = sm_pages::select('domain')->groupBy('domain')
                    ->orderBy('domain', 'asc')
                    ->get()
                    ->toArray();
                foreach ($data as $key => $site_data) {
                    $status_redirect = sm_pages::where('domain', '=', $site_data['domain'])->where('http_status_code', 'like', '3%')
                        ->count();
                    $status_error = sm_pages::where('domain', '=', $site_data['domain'])->where('http_status_code', 'like', '4%')
                        ->orWhere('http_status_code', 'like', '5%')
                        ->count();

                    if ($status_error > 0) {
                        $data[$key]['status'] = 'error';
                    } elseif ($status_redirect > 0) {
                        $data[$key]['status'] = 'redirect';
                    } else {
                        $data[$key]['status'] = 'success';
                    }
                }
            }

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->post('/api/sm_site/{domain}', function (Request $request, Response $response, array $args) {
            /* mass update. Return number of updated rows for every param */
            $data = [];
            $updated_fileds = $request->getParsedBody();
            foreach ($updated_fileds as $key => $value) {
                $data[$key] = sm_pages::where('domain', '=', $args['domain'])->update([
                    $key => $value
                ]);
            }

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->delete('/api/sm_site/{domain}', function (Request $request, Response $response, array $args) {
            /* return number of deleted rows */
            $data = sm_pages::where('domain', '=', $args['domain'])->delete();

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        // $this->app->delete('/api/sm_site/{page_id}', function (Request $request, Response $response, array $args) {
        // $data = sm_pages::where('domain', '=', $args['domain'])->delete();

        // return $response->withStatus(200)
        // ->withHeader('Content-Type', 'application/json')
        // ->write(json_encode($data));
        // });

        $this->app->map([
            'GET',
            'POST'
        ], '/api/get_config', function (Request $request, Response $response, $args) {
            $data = [];
            foreach (config::all() as $config) {
                $data[$config->config_key] = $config->config_value;
            }
            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->map([
            'GET',
            'POST'
        ], '/api/get_user[/{id}]', function (Request $request, Response $response, $args) {
            if ($args['id']) {
                $data = users::select([
                    'user_id',
                    'login',
                    'email',
                    'create_time',
                    'update_time'
                ])->find($args['id'])
                    ->toArray();
            } else {
                $data = users::where('login', $_SERVER['PHP_AUTH_USER'])->select([
                    'user_id',
                    'login',
                    'email',
                    'create_time',
                    'update_time'
                ])
                    ->first()
                    ->toArray();
            }

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->post('/api/update_config', function (Request $request, Response $response, $args) {
            $data = [];

            $config_list = $request->getParsedBody();
            foreach ($config_list as $key => $value) {
                $config = config::where('config_key', $key)->first();
                $config->config_value = $value;
                $config->save();
            }

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->post('/api/update_user', function (Request $request, Response $response, $args) {
            $data = [];

            $new_data = $request->getParsedBody();
            $user = users::find($new_data['user_id']);
            unset($new_data['user_id']);
            unset($new_data['create_time']);
            unset($new_data['update_time']);
            foreach ($new_data as $key => $value) {
                $user->$key = $value;
            }
            $user->save();

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });

        $this->app->post('/api/update_password', function (Request $request, Response $response, $args) {
            $data = [];

            $user = users::find($request->getParsedBody()['user_id']);
            $user->password = $request->getParsedBody()['password'];
            $user->save();

            return $response->withStatus(200)
                ->withHeader('Content-Type', 'application/json')
                ->write(json_encode($data));
        });
    }

    protected function auth_init()
    {
        /* @var $realm Model */
        foreach (realms::all() as $realm) {
            $users_list = [];
            foreach (permissions::where('realm_id', $realm->realm_id)->pluck('user_id') as $user_id) {
                /* @var $user Model */
                $user = users::find($user_id);
                $users_list[$user->login] = $user->password;
            }

            if (config::where('config_key', 'app_secure')->select('config_value') == "true") {
                $secure = true;
            } else {
                $secure = false;
            }

            /* @var $path Model */
            foreach (path_realm::where('realm_id', $realm->realm_id)->get() as $path) {
                $this->app->add(new HttpBasicAuthentication([
                    "path" => $path->ac_path,
                    "realm" => $realm->name,
                    "secure" => $secure,
                    "users" => $users_list
                ]));
            }
        }
    }

    protected function mailer_init()
    {
        // Get container
        $container = $this->app->getContainer();

        // Register component on container
        $container['mail'] = function ($container) {
            $mail = new PHPMailer(true);
            return $mail;
        };
    }

    protected function template_engine_init()
    {
        // Get container
        $container = $this->app->getContainer();

        // Register component on container
        $container['view'] = function ($container) {
            if (DEV_MODE) {
                $settings = array(
                    'cache' => false
                );
            } else {
                $settings = array(
                    'cache' => $this->cache_folder
                );
            }
            $view = new Twig($this->template_folder, $settings);

            // Instantiate and add Slim specific extension
            $router = $container->get('router');
            $uri = \Slim\Http\Uri::createFromEnvironment(new \Slim\Http\Environment($_SERVER));
            $view->addExtension(new TwigExtension($router, $uri));

            return $view;
        };
    }

    function run()
    {
        $this->app->run();
    }

    static function get_config()
    {
        $config = config::all();
        return $config;
    }
}
