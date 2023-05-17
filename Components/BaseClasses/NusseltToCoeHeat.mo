within slPCMlib.Components.BaseClasses;
function NusseltToCoeHeat "Return coefficient of heat transfer from Nusselt number"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Temperature T "Thermodynamic state record";
  input Modelica.Units.SI.Length L "Tube length";
  input Modelica.Units.SI.Length di "Tube inner diameter";
  //input Modelica.Units.SI.ThermalConductivity kf=0.598 "Thermal conductivity, 0.598 for water used in MBL";
  input Modelica.Units.SI.PrandtlNumber Pr "Prandtl number";
  input Modelica.Units.SI.ReynoldsNumber Re "Reynolds number";
  input Modelica.Units.SI.ThermalConductivity kf=-8.354e-6 * T^2 + 6.53e-3 * T - 0.5981
    "Thermal conductivity, W. Kays, M. Crawford, B. Weigand, Convective Heat and Mass Transfer, 
     fourth ed., McGraw-Hill, Singapore, 2005.";
  output Modelica.Units.SI.CoefficientOfHeatTransfer hf "Coefficient of heat transfer";

protected
  Modelica.Units.SI.NusseltNumber Nu "Nusselt number";

algorithm
  //n=0.3 for cooling and 0.4 for heating, currently use 0.35 for convenience
  Nu := if Re < 2300 then 3.66+(0.0668*(di/L)*Re*Pr)/(1+0.04*((di/L)*Re*Pr)^(2/3)) else 0.023*(Re^0.8)*(Pr^0.35);
  hf := Nu*kf/di;
  annotation (Documentation(info="Nusselt number Nu = alpha*D/lambda"));
end NusseltToCoeHeat;
