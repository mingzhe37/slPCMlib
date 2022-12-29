within slPCMlib.Examples;
model examplePCMtank "Example using PCM tank"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure difference";

  PCMtank tank(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=4.5,
    f=0.001,
    offset=273.15 + 28) annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(sou.ports[1], tank.port_a) annotation (Line(points={{-34,0},{-10,0}}, color={0,127,255}));
  connect(tank.port_b, res.port_a) annotation (Line(points={{10,0},{26,0}}, color={0,127,255}));
  connect(res.port_b, bou.ports[1]) annotation (Line(points={{46,0},{60,0}}, color={0,127,255}));
  connect(sou.T_in, sine.y) annotation (Line(points={{-56,4},{-74,4},{-74,0},{-79,0}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
Dec 25, 2022, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Example to show the use of PCM tank model.</p>
</html>"));
end examplePCMtank;
