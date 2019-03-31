<?php
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Events\Dispatcher;
use Illuminate\Container\Container;
use cntrl\master;

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config.php';

// Setup the Eloquent ORM
$capsule = new Capsule();
$capsule->addConnection(DB_CONF_MAIN, 'main_db');

// Set the event dispatcher used by Eloquent models
$capsule->setEventDispatcher(new Dispatcher(new Container));

$capsule->bootEloquent();

$master = new master();
$master->run();