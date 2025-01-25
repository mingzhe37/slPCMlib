within slPCMlib.Examples;
model example_HPWatPCM "Example using PCM tank"
  extends Modelica.Icons.Example;

  replaceable package MediumW = Buildings.Media.Water;
  replaceable package MediumA = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.15
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure difference";

  Components.PCMtank_heaFlo
                        pCMtank_heaFlo(
    redeclare package Medium = MediumW,
    m_flow_nominal=0.1,
    dp_nominal=500,
    nTub=1,
    Rmax=0.055,
    Ro=0.03,
    Ri=0.028,
    L=174,
    PCM_t_ini=288.15,
    m=233)
          annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,10})));
  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    per=per) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,10})));
  parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Trane_Axiom_EXW240
                                                          per
   "Reversible heat pump performance data"
   annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                           souPum(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    use_T_in=true,
    nPorts=1)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-120,-70})));
  Modelica.Fluid.Sources.FixedBoundary souVol(redeclare package Medium = Medium,
      nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-120,70})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse
                                       TSouEnt(
    amplitude=3,
    width=0.7,
    period=200,
    offset=25 + 273.15)
    "Source side entering water temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-158,-70})));
  Buildings.Fluid.FixedResistances.Junction jun
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Fluid.FixedResistances.Junction jun1
    annotation (Placement(transformation(extent={{0,-60},{-20,-80}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(redeclare package
      Medium1 = MediumW, redeclare package Medium2 = MediumA)
                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,10})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-84,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1 annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-84,-22})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={64,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={64,-30})));
  Buildings.Fluid.Movers.FlowControlled_m_flow mov(redeclare package Medium =
        MediumW) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-84,-50})));
equation
  connect(souPum.T_in, TSouEnt.y) annotation (Line(points={{-132,-66},{-132,-70},
          {-146,-70}}, color={0,0,127}));
  connect(pCMtank_heaFlo.port_b, jun1.port_3)
    annotation (Line(points={{-10,0},{-10,-60}}, color={0,127,255}));
  connect(jun.port_3, pCMtank_heaFlo.port_a)
    annotation (Line(points={{-10,60},{-10,20}}, color={0,127,255}));
  connect(senTem.port_b, jun.port_1)
    annotation (Line(points={{-84,60},{-84,70},{-20,70}}, color={0,127,255}));
  connect(jun.port_2, senTem2.port_a)
    annotation (Line(points={{0,70},{64,70},{64,60}}, color={0,127,255}));
  connect(senTem2.port_b, hex.port_a1)
    annotation (Line(points={{64,40},{64,20}}, color={0,127,255}));
  connect(jun1.port_1, senTem3.port_b)
    annotation (Line(points={{0,-70},{64,-70},{64,-40}}, color={0,127,255}));
  connect(senTem3.port_a, hex.port_b1)
    annotation (Line(points={{64,-20},{64,0}}, color={0,127,255}));
  connect(senTem.port_a, heaPum.port_b2)
    annotation (Line(points={{-84,40},{-84,20}}, color={0,127,255}));
  connect(senTem1.port_b, heaPum.port_a2)
    annotation (Line(points={{-84,-12},{-84,0}}, color={0,127,255}));
  connect(souVol.ports[1], heaPum.port_a1)
    annotation (Line(points={{-110,70},{-96,70},{-96,20}}, color={0,127,255}));
  connect(souPum.ports[1], heaPum.port_b1) annotation (Line(points={{-110,-70},
          {-96,-70},{-96,0}}, color={0,127,255}));
  connect(jun1.port_2, mov.port_a) annotation (Line(points={{-20,-70},{-84,-70},
          {-84,-60}}, color={0,127,255}));
  connect(mov.port_b, senTem1.port_a)
    annotation (Line(points={{-84,-40},{-84,-32}}, color={0,127,255}));
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
</html>"),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"));
end example_HPWatPCM;
