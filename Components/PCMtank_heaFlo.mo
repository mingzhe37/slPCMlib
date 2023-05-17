within slPCMlib.Components;
model PCMtank_heaFlo "A PCM storage tank model"
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
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Heat flow rate, positive if flow from outside into tank" annotation (Placement(transformation(extent={{100,
            30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput Xi(final unit="1")
    "Liquid mass phase fraction" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));

  Components.HeatCapacitorSlPCMlib PCMCap(
    m=m,
    T(start=PCM_t_ini),
    redeclare package PCM = Media_generic.generic_7thOrderSmoothStep,
    redeclare Interfaces.phTransModMeltingCurve phTrModel)
    "Capacitor of PCM" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));

  Modelica.Blocks.Interfaces.RealOutput Phi(final unit="1") "Liquid volume phase fraction" annotation (
      Placement(transformation(extent={{100,-90},{120,-70}}), iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput h(final unit="J/kg") "Specific enthalpy" annotation (Placement(
        transformation(extent={{100,50},{120,70}}), iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Sources.RealExpression PCMh(y=PCMCap.phTrModel.h)
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.Blocks.Sources.RealExpression Qflo(y=PCMCap.port.Q_flow)
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Modelica.Blocks.Sources.RealExpression PCMXi(y=PCMCap.phTrModel.xi)
    annotation (Placement(transformation(extent={{48,-70},{68,-50}})));
  Modelica.Blocks.Sources.RealExpression PCMPhi(y=PCMCap.phTrModel.phi)
    annotation (Placement(transformation(extent={{48,-90},{68,-70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
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
    annotation (Placement(transformation(extent={{14,42},{26,54}})));
  Modelica.Blocks.Sources.RealExpression TIn(final y=Medium.temperature(state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)))) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaHTF
    annotation (Placement(transformation(extent={{-8,10},{-20,22}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaPCM
    annotation (Placement(transformation(extent={{-8,24},{-20,36}})));
  Modelica.Blocks.Sources.RealExpression deltaT(final y=CMin_flow*(Medium.temperature(state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow))) - PCMCap.port.T)) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Product pro annotation (Placement(transformation(extent={{-10,42},{2,54}})));
  Modelica.Blocks.Math.Gain neg(k=-1) "Gain block to account for the number of tubes"
    annotation (Placement(transformation(extent={{26,10},{14,22}})));
protected
  Modelica.Units.SI.ThermalConductance CMin_flow = m_flow*Medium.specificHeatCapacityCp(
        state=Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)));
equation
  connect(PCMPhi.y, Phi) annotation (Line(points={{69,-80},{110,-80}}, color={0,0,127}));
  connect(PCMXi.y, Xi) annotation (Line(points={{69,-60},{110,-60}}, color={0,0,127}));
  connect(PCMh.y, h) annotation (Line(points={{71,60},{110,60}}, color={0,0,127}));
  connect(Qflo.y, Q_flow) annotation (Line(points={{71,40},{110,40}}, color={0,0,127}));
  connect(PCMCap.port, temSen.port) annotation (Line(points={{-70,-60},{0,-60}}, color={191,0,0}));
  connect(masFloSen.m_flow, hATube.m_flow) annotation (Line(points={{-80,6.6},{-80,43},{-51,43}}, color={0,0,127}));
  connect(PCMfrac.y, hATube.theta) annotation (Line(points={{-79,66},{-68,66},{-68,53},{-51,53}}, color={0,0,127}));
  connect(cpHTF.y, hATube.cp) annotation (Line(points={{-79,82},{-60,82},{-60,57},{-51,57}}, color={0,0,127}));
  connect(TIn.y, hATube.T_HTF) annotation (Line(points={{-79,50},{-70,50},{-70,47},{-51,47}}, color={0,0,127}));
  connect(temSen.T, T) annotation (Line(points={{21,-60},{40,-60},{40,-40},{110,-40}}, color={0,0,127}));
  connect(pro.y, gai.u) annotation (Line(points={{2.6,48},{12.8,48}}, color={0,0,127}));
  connect(deltaT.y, pro.u1) annotation (Line(points={{-19,80},{-16,80},{-16,51.6},{-11.2,51.6}}, color={0,0,127}));
  connect(hATube.eps, pro.u2)
    annotation (Line(points={{-29,54},{-20,54},{-20,44},{-12,44},{-12,44.4},{-11.2,44.4}}, color={0,0,127}));
  connect(gai.y, preHeaPCM.Q_flow) annotation (Line(points={{26.6,48},{40,48},{40,30},{-8,30}}, color={0,0,127}));
  connect(preHeaPCM.port, PCMCap.port)
    annotation (Line(points={{-20,30},{-30,30},{-30,-60},{-70,-60}}, color={191,0,0}));
  connect(gai.y, neg.u) annotation (Line(points={{26.6,48},{40,48},{40,16},{27.2,16}}, color={0,0,127}));
  connect(neg.y, preHeaHTF.Q_flow) annotation (Line(points={{13.4,16},{-8,16}}, color={0,0,127}));
  connect(preHeaHTF.port, vol.heatPort)
    annotation (Line(points={{-20,16},{-26,16},{-26,-10},{-9,-10}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
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
end PCMtank_heaFlo;
