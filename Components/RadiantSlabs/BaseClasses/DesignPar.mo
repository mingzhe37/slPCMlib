within slPCMlib.Components.RadiantSlabs.BaseClasses;
record DesignPar "Design parameters for radiant cooling system"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_Sou "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_Sou=-QCoo_flow_nominal_Sou/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_Eas "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_Eas=-QCoo_flow_nominal_Eas/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_Nor "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_Nor=-QCoo_flow_nominal_Nor/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_Wes "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_Wes=-QCoo_flow_nominal_Wes/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal_Cor "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_Cor=-QCoo_flow_nominal_Cor/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Modelica.Units.SI.Length Radiant_loop_spacing "Design radiant loop spacing" annotation(unit="m");

  parameter Modelica.Units.SI.Length PCM_thickness "PCM layer thickness" annotation(unit="m");

  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal_sys =
  mCoo_flow_nominal_Sou+mCoo_flow_nominal_Eas+mCoo_flow_nominal_Nor+mCoo_flow_nominal_Wes+mCoo_flow_nominal_Cor
  "Design total water mass flow rate for system";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end DesignPar;
