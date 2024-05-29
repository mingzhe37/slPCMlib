within slPCMlib.Components;
model PCMtank_hA "A PCM storage tank model"
  extends slPCMlib.Components.BaseClasses.TwoPortHeatMassExchanger(
    final allowFlowReversal=false,
    final tau=tauHex,
    final energyDynamics=energyDynamicsHex,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

  parameter Real nTub(min=0)=nTub
   "Gain value multiplied with input signal";
  parameter Modelica.Units.SI.Length Rmax
   "maximum radius, interacting with other tube";
  parameter Modelica.Units.SI.Length Ro
   "outer radius of tube";
  parameter Modelica.Units.SI.Length Ri
   "inner radius of tube";
  parameter Modelica.Units.SI.Length L
   "tube length";

  parameter Modelica.Units.SI.Temperature PCM_t_ini=323.15
   "Start value for PCM component";
  parameter Modelica.Units.SI.Mass m(displayUnit="kg") = 0.100
   "Mass of PCM element";
  parameter Modelica.Units.SI.Time tauHex(min=1) = 30
   "Time constant of working fluid through the heat exchanger at nominal flow"
     annotation (Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
   Modelica.Fluid.Types.Dynamics.FixedInitial
   "Formulation of energy balance for heat exchanger internal fluid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        p=Medium.p_default,
        T=Medium.T_default,
        X=Medium.X_default))
    "Specific heat capacity of working fluid";

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Temperature of the fluid leaving at port_b"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Heat flow rate, positive if flow from outside into tank" annotation (Placement(transformation(extent={{100,
            30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput Xi(final unit="1")
    "Liquid mass phase fraction" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));

  Components.HeatCapacitorSlPCMlib PCMCap(
    m=m,
    T(start=PCM_t_ini),
    redeclare package PCM = slPCMlib.Media_Axiotherm_ATP.Axiotherm_ATP_12,
    redeclare Interfaces.phTransModMeltingCurve phTrModel)
    "Capacitor of PCM" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));

  Modelica.Blocks.Interfaces.RealOutput Phi(final unit="1") "Liquid volume phase fraction" annotation (
      Placement(transformation(extent={{100,-100},{120,-80}}),iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput h(final unit="J/kg") "Specific enthalpy" annotation (Placement(
        transformation(extent={{100,70},{120,90}}), iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.RealExpression PCMh(y=PCMCap.phTrModel.h)
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Modelica.Blocks.Sources.RealExpression Qflo(y=PCMCap.port.Q_flow)
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Modelica.Blocks.Sources.RealExpression PCMXi(y=PCMCap.phTrModel.xi)
    annotation (Placement(transformation(extent={{48,-70},{68,-50}})));
  Modelica.Blocks.Sources.RealExpression PCMPhi(y=PCMCap.phTrModel.phi)
    annotation (Placement(transformation(extent={{48,-100},{68,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con(dT(min=-200)) "Convection (and conduction) on fluid side"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  BaseClasses.HATube hATube(
    Rmax=Rmax,
    Ro=Ro,
    Ri=Ri,
    L=L)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Blocks.Sources.RealExpression PCMfrac(y=PCMCap.phTrModel.xi)
    annotation (Placement(transformation(extent={{-100,56},{-80,76}})));
  Modelica.Blocks.Sources.RealExpression cpHTF(y=Medium.specificHeatCapacityCp(state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow))))
    annotation (Placement(transformation(extent={{-100,72},{-80,92}})));
  Modelica.Blocks.Math.Gain gai(k=nTub) "Gain block to account for the number of tubes"
    annotation (Placement(transformation(extent={{-20,40},{-8,52}})));
  Modelica.Blocks.Sources.RealExpression TIn(final y=Medium.temperature(state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)))) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
protected
  Modelica.Units.SI.ThermalConductance CMin_flow = m_flow*Medium.specificHeatCapacityCp(
        state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)));
equation
  connect(PCMPhi.y, Phi) annotation (Line(points={{69,-90},{110,-90}}, color={0,0,127}));
  connect(PCMXi.y, Xi) annotation (Line(points={{69,-60},{110,-60}}, color={0,0,127}));
  connect(PCMh.y, h) annotation (Line(points={{71,80},{110,80}}, color={0,0,127}));
  connect(Qflo.y, Q_flow) annotation (Line(points={{71,40},{110,40}}, color={0,0,127}));
  connect(PCMCap.port, temSen.port) annotation (Line(points={{-70,-60},{0,-60}}, color={191,0,0}));
  connect(vol.heatPort, con.fluid)
    annotation (Line(points={{-9,-10},{-14,-10},{-14,-30},{-20,-30}}, color={191,0,0}));
  connect(con.solid, PCMCap.port)
    annotation (Line(points={{-40,-30},{-50,-30},{-50,-60},{-70,-60}}, color={191,0,0}));
  connect(masFloSen.m_flow, hATube.m_flow) annotation (Line(points={{-80,6.6},{-80,43},{-51,43}}, color={0,0,127}));
  connect(PCMfrac.y, hATube.theta) annotation (Line(points={{-79,66},{-68,66},{-68,53},{-51,53}}, color={0,0,127}));
  connect(cpHTF.y, hATube.cp) annotation (Line(points={{-79,82},{-60,82},{-60,57},{-51,57}}, color={0,0,127}));
  connect(hATube.UA, gai.u) annotation (Line(points={{-29,46},{-21.2,46}}, color={0,0,127}));
  connect(gai.y, con.Gc)
    annotation (Line(points={{-7.4,46},{0,46},{0,20},{-30,20},{-30,-20}},                     color={0,0,127}));
  connect(TIn.y, hATube.T_HTF) annotation (Line(points={{-79,50},{-70,50},{-70,47},{-51,47}}, color={0,0,127}));
  connect(temSen.T, T) annotation (Line(points={{21,-60},{40,-60},{40,-30},{110,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,70},{100,-70}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-100,100},{100,40}},
          lineColor={0,0,0},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,80},{88,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{68,78},{86,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{100,120},{160,80}},
          textColor={0,0,88},
          textString="Specific_h"),
        Text(
          extent={{100,68},{140,48}},
          textColor={0,0,88},
          textString="Q_flow"),
        Text(
          extent={{100,-6},{120,-26}},
          textColor={0,0,88},
          textString="T"),
        Text(
          extent={{100,-36},{140,-56}},
          textColor={0,0,88},
          textString="SOC_mas"),
        Text(
          extent={{100,-66},{132,-86}},
          textColor={0,0,88},
          textString="SOC_liq"),
        Ellipse(
          extent={{36,80},{58,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,78},{56,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{6,80},{28,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{8,78},{26,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,96},{42,80}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{22,94},{40,82}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,96},{12,80}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-8,94},{10,82}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,96},{-18,80}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-38,94},{-20,82}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,80},{-2,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,78},{-4,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,80},{-32,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-52,78},{-34,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-84,80},{-62,64}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,78},{-64,66}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,62},{44,46}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{24,60},{42,48}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-8,62},{14,46}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-6,60},{12,48}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,62},{-16,46}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-36,60},{-18,48}},
          lineColor={0,0,0},
          fillColor={213,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-100,-34},{98,-102}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          closure=EllipseClosure.Radial,
          startAngle=0,
          endAngle=180,
          pattern=LinePattern.None),
        Text(
          extent={{-68,-12},{72,-32}},
          textColor={255,255,255},
          textStyle={TextStyle.Bold},
          textString="PCM Tank")}),                              Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>A PCM tank model, based on Modelica iLPCMlib Library. </p>
</html>", revisions="<html>
<ul>
<li>
Dec 25, 2022, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PCMtank_hA;
