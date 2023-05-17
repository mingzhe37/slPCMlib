within slPCMlib.Components.Examples;
model hATest

  Modelica.Blocks.Sources.RealExpression m_flow(y=0.01)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.RealExpression Twat(y=273.15 + 20)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=4184)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.RealExpression m_flow1(y=hATube.m_flow/(Modelica.Constants.pi*hATube.Ri*hATube.Ri))
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=0.9,
    duration=5,
    offset=0.1) annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(m_flow.y, hATube.m_flow) annotation (Line(points={{-59,50},{-28,50},{-28,37},{-21,37}}, color={0,0,127}));
  connect(Twat.y, hATube.T_HTF) annotation (Line(points={{-59,30},{-26,30},{-26,33},{-21,33}}, color={0,0,127}));
  connect(realExpression3.y, hATube.cp) annotation (Line(points={{-59,-10},{-21,-10},{-21,23}}, color={0,0,127}));
  connect(ramp.y, hATube.theta) annotation (Line(points={{-79,10},{-26,10},{-26,27},{-21,27}}, color={0,0,127}));
end hATest;
