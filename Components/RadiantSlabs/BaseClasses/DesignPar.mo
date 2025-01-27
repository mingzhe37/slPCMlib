within slPCMlib.Components.RadiantSlabs.BaseClasses;
record DesignPar "Design parameters for radiant cooling system"
  extends Modelica.Icons.Record;

  parameter Real QCoo_flow_nominal_Sou "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Real mCoo_flow_nominal_Sou=-QCoo_flow_nominal_Sou/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Real QCoo_flow_nominal_Eas "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Real mCoo_flow_nominal_Eas=-QCoo_flow_nominal_Eas/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Real QCoo_flow_nominal_Nor "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Real mCoo_flow_nominal_Nor=-QCoo_flow_nominal_Nor/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Real QCoo_flow_nominal_Wes "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Real mCoo_flow_nominal_Wes=-QCoo_flow_nominal_Wes/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");

  parameter Real QCoo_flow_nominal_Cor "Nominal heat flow rate for cooling" annotation(unit="W");
  parameter Real mCoo_flow_nominal_Cor=-QCoo_flow_nominal_Cor/4200/5
                                       "Design water mass flow rate for heating" annotation(unit="kg/s");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end DesignPar;
