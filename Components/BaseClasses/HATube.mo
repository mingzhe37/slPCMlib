within slPCMlib.Components.BaseClasses;
model HATube "Overall heat transfer model for tubes in PCM tank"
  extends Modelica.Blocks.Icons.Block;

  //thermal resistance of each layer, HTF || Tube || PCM
  Modelica.Units.SI.ThermalResistance R_T "total thermal resistance";
  Modelica.Units.SI.ThermalResistance R_HTF "heat transfer fluid thermal resistance";
  Modelica.Units.SI.ThermalResistance R_WALL "tube wall thermal resistance";
  Modelica.Units.SI.ThermalResistance R_PCM "pcm thermal resistance";

  //thermal conductivity of tube wall and PCM
  Modelica.Units.SI.ThermalConductivity kw=385 "Thermal conductivity of tube wall, copper"
  annotation (Dialog(tab="General", group="Nominal condition"));
  Modelica.Units.SI.ThermalConductivity kpcm=0.25 "Thermal conductivity of pcm, generic_7thOrder, (0.2+0.3)/2"
  annotation (Dialog(tab="General", group="Nominal condition"));

  //geometry parameters
  parameter Modelica.Units.SI.Length Rmax "maximum radius, interacting with other tube"
  annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.Length Ro "outer radius of tube"
  annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.Length Ri "inner radius of tube"
  annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.Length L "tube length"
  annotation (Dialog(tab="General", group="Nominal condition"));

  //block inputs
  Modelica.Blocks.Interfaces.RealInput m_flow(final unit="kg/s") "Mass flow rate heat transfer fluid"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput T_HTF(final unit="K") "Temperature heat transfer fluid"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput theta(final unit="1") "pcm phase change fraction"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput cp(final quantity="SpecificHeatCapacity",
      final unit="J/(kg.K)") "heat transfer fluid heat capacity"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  //block outputs
  Modelica.Blocks.Interfaces.RealOutput UA(final unit="W/K")
    "overall heat transfer coefficient" annotation (Placement(transformation(
          extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput NTU(final unit="1")
    "NTU" annotation (Placement(transformation(
          extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput eps(final unit="1")
    "heat exchanger effectiveness" annotation (Placement(transformation(
          extent={{100,30},{120,50}})));

  //unitless numbers
protected
  Modelica.Units.SI.ReynoldsNumber Re "Reynolds number";

  Modelica.Units.SI.PrandtlNumber Pr "Prandtl number";

  Modelica.Units.SI.CoefficientOfHeatTransfer hf "Coefficient of heat transfer";

algorithm
  Re := Buildings.Utilities.Math.Functions.smoothMax(
        x1=10,
        x2=slPCMlib.Components.BaseClasses.ReynoldsNumber_m_flow(
        m_flow,
        slPCMlib.Components.BaseClasses.dynamicViscosityWater(T_HTF),
        Ri*2),
        deltaX=1E-5);

  Pr := slPCMlib.Components.BaseClasses.prandtlNumberWater(T_HTF);

  hf := slPCMlib.Components.BaseClasses.NusseltToCoeHeat(T_HTF, L, Ri*2, Pr, Re);

equation
  //calculate each thermal resistance, HTF || tube || PCM
  R_HTF = 1 / (2*Modelica.Constants.pi*Ri*L*hf);
  R_WALL = log(Ro/Ri)/(2*Modelica.Constants.pi*kw*L);
  R_PCM = (log((theta*(Rmax^2 - Ro^2) + Ro^2)^(1/2)/Ro))/(2*Modelica.Constants.pi*L*kpcm);
  R_T = R_HTF + R_WALL + R_PCM;

  //output concerned variables
  UA = 1 / R_T;
  NTU = UA / (m_flow*cp);
  eps = 1 - exp(-1/(m_flow*cp*R_T));

annotation (Documentation(info="<html>
<p>A simplified mathematical representation has been analytically developed using the &epsilon;-NTU technique for a cylindrical tank filled with phase change material (PCM), with heat transfer fluid flowing through tubes inside the tank. </p>
<p><b>References</b></p>
<ul>
<li>N.H.S. Tay, <a href=\"https://www.sciencedirect.com/science/article/pii/S0306261911006441?via%3Dihub\">An effectiveness-NTU technique for characterising tube-in-tank phase change thermal energy storage systems</a>, Applied Energy Volume 91, Issue 1, March 2012, Pages 309-319. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2017, by Michael Wetter:<br/>
Corrected coefficient in Taylor expansion of <code>x_a</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/698\">#698</a>.
</li>
<li>
June 8, 2010, by Michael Wetter:<br/>
Fixed bug in computation of <code>s_w</code>.
The old implementation used the current inlet water temperature instead
of the design condition that corresponds to <code>UA_nominal</code>.
</li>
<li>
April 16, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={            Text(
          extent={{-60,90},{66,0}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="hA"),
        Ellipse(
          extent={{-32,-10},{-12,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,-10},{54,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-10},{20,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,-10},{-44,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,-40},{-28,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,-40},{4,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,-40},{36,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,-40},{70,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,-66},{-48,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-66},{-16,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,-66},{16,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-66},{50,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end HATube;
