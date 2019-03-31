<?php
namespace cntrl;

use model\sm_pages;

class SitesMonitor extends sub_controller implements sub_controller_interface
{

    protected function update_data()
    {
        if ($this->args['id']) {
            $this->render_data['domain']=$this->args['id'];
            
            $last_date = new \DateTime(sm_pages::select('last_check_time')->where('domain','=',$this->args['id'])->orderBy('last_check_time','DESC')->first()->toArray()['last_check_time']);
            $this->render_data['last_check_date']=$last_date->format('Y-m-d H:i:s');
            
        }
    }
}