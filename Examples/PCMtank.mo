within slPCMlib.Examples;
model PCMtank "A PCM storage tank model"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final allowFlowReversal = true,
    final tau=tauHex,
    final energyDynamics=energyDynamicsHex,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

  parameter Modelica.Units.SI.Temperature PCM_t_ini=323.15
   "Start value for PCM component";

  parameter Modelica.Units.SI.Mass m(displayUnit="kg") = 0.100
    "Mass of PCM element";

  parameter Modelica.Units.SI.Time tauHex(min=1) = 30
    "Time constant of working fluid through the heat exchanger at nominal flow"
     annotation (Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance for heat exchanger internal fluid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Temperature of the fluid leaving at port_b"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Heat flow rate, positive if flow from outside into tank" annotation (Placement(transformation(extent={{100,
            30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput Xi(final unit="1") "Liquid mass phase fraction" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));

  Components.HeatCapacitorSlPCMlib PCMCap(
    m=m,
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(PCMPhi.y, Phi) annotation (Line(points={{69,-80},{110,-80}}, color={0,0,127}));
  connect(PCMXi.y, Xi) annotation (Line(points={{69,-60},{110,-60}}, color={0,0,127}));
  connect(PCMh.y, h) annotation (Line(points={{71,60},{110,60}}, color={0,0,127}));
  connect(Qflo.y, Q_flow) annotation (Line(points={{71,40},{110,40}}, color={0,0,127}));
  connect(PCMCap.port, vol.heatPort)
    annotation (Line(points={{-70,-60},{-20,-60},{-20,-10},{-9,-10}}, color={191,0,0}));
  connect(PCMCap.port, temperatureSensor.port)
    annotation (Line(points={{-70,-60},{0,-60},{0,-50}}, color={191,0,0}));
  connect(temperatureSensor.T, T)
    annotation (Line(points={{21,-50},{30,-50},{30,80},{110,80}}, color={0,0,127}));
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
end PCMtank;
