def stub_flash_sweeper
  controller.instance_eval{flash.stub!(:sweep)} 
end
