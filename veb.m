 

model ="freevebnodamp";

open_system(new_system(model));
    
    add_block('simulink/Commonly Used Blocks/ Integrator',[model '/Integrator1']);
    add_block('simulink/Commonly Used Blocks/ Integrator', [model '/Integrator2']);
    add_block('simulink/Commonly Used Blocks/ Sum', [model '/Sum']);
    add_block('simulink/Commonly Used Blocks/ spring', [model '/spring']);
    add_block('simulink/Commonly Used Blocks/ mass', [model '/mass']);
    add_block('simulink/Commonly Used Blocks/ scope', [model '/scope']);
    add_block('simulink/Commonly Used Blocks/ workspace', [model '/workspace']);

   m=2;
   k=15;

   set_param([model '/Integrator1'],'v0','2');
   set_param([model '/Integrator2'],'x0','0.2');

 set_param([model '/Spring'], 'Gain', num2str(-k));
 set_param([model '/Mass'], 'Gain', num2str(1/ m)); 
 set_param([model '/To Workspace'], 'VariableName', 'displacement');
 add_line(model, 'Integrator1/1', 'Integrator2/1');
 add_line(model, 'Integrator2/1', 'Spring/1'); 
 add_line(model, 'Spring/1', 'Sum/1');
 add_line(model, 'Sum/1', 'Mass/1');
 add_line(model, 'Mass/1', 'Integrator1/1');
 add_line (model, 'Integrator2/1', 'Scope/1');
 add_line(model, 'Integrator2/1', 'To Workspace/ 1');
 save_system (model);
%___________________________________________________________________________________-
model ="freevebyedamp";

open_system(new_system(model));
    
    add_block('simulink/Commonly Used Blocks/ Integrator',[model '/Integrator1']);
    add_block('simulink/Commonly Used Blocks/ Integrator', [model '/Integrator2']);
    add_block('simulink/Commonly Used Blocks/ Sum', [model '/Sum']);
    add_block('simulink/Commonly Used Blocks/ spring', [model '/spring']);
    add_block('simulink/Commonly Used Blocks/ mass', [model '/mass']);
    add_block('simulink/Commonly Used Blocks/ scope', [model '/scope']);
    add_block('simulink/Commonly Used Blocks/ workspace', [model '/workspace']);
add_block('simulink/Commonly Used Blocks/ damper', [model '/damper']);
   m=10;
   k=50;
   c=6;
   set_param([model '/Integrator1'],'v0','2');
   set_param([model '/Integrator2'],'x0','0.2');
  
 set_param([model '/Spring'], 'Gain', num2str(-k));
 set_param([model '/Mass'], 'Gain', num2str(1/ m));
 set_param([model '/damper'], 'Gain', num2str(1/-c));
 set_param([model '/To Workspace'], 'VariableName', 'displacement');






 add_line(model, 'Integrator1/1', 'damper/1');
 add_line(model, 'Integrator1/1', 'Integrator2/1');
 add_line(model, 'Integrator2/1', 'Spring/1'); 
 add_line(model, 'Spring/1', 'Sum/1');
 add_line(model, 'Sum/1', 'Mass/1');
 add_line(model, 'Mass/1', 'Integrator1/1');
 add_line (model, 'Integrator2/1', 'Scope/1');
 add_line(model, 'Integrator2/1', 'To Workspace/ 1');
 save_system (model);

 %____________________________________________________________________________

 sim_time=10;
 sim('freevebnodamp',sim_time);
 displacement_without_damping =displacement;
 sim('freevenyedamp',sim_time);
 displacement_with_damping =displacement;

 figure;
 plot( displacement_without_damping.time,displacement_with_damping.values );
 xlabel("t");
 ylabel("x");

 figure;
  plot( displacement_with_damping.time,displacement_without_damping.values );
  xlabel("t");
 ylabel("x");


[pks_without, locs_without] = findpeaks(displacement_without_damping,signals,values);
period_without =mean(diff(locs_without));

natural_frequency_without = 2 *pi /period_without;

[pks_with, locs_with] = findpeaks(displacement_with_damping,signals,values);
period_with =mean(diff(locs_with)); 


natural_frequency_with = 2 *pi /period_with;

fprintf('2.%:fwithout rad/s\n',natural_frequency_without);
fprintf('2.%:fwith rad/s\n',natural_frequency_with);

