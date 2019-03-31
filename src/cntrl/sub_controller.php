<?php
namespace cntrl;

use Illuminate\Database\Eloquent\Model;
use Slim\App;
use Slim\Container;

interface sub_controller_interface
{

    public function get_render_data();
}

class sub_controller
{

    protected $args;

    protected $container;

    protected $sub;

    protected $render_data;

    final function __construct(Container $container, Model $sub, $render_data, $args = [])
    {
        $this->container = $container;
        $this->sub = $sub;
        $this->render_data = $render_data;
        $this->args = $args;
        $this->update_data();
    }

    protected function update_data($param)
    {
        // $$this->render_data[$key] = 'value';
    }

    public function get_render_data()
    {
        return $this->render_data;
    }
}