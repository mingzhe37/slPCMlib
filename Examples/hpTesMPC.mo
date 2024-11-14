within slPCMlib.Examples;
model hpTesMPC "Example using PCM tank"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air;
  replaceable package MediumW = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.53
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")=1000
    "Pressure difference";

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    annotation (Placement(transformation(extent={{-66,-66},{-52,-52}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumW, nPorts=1)
    annotation (Placement(transformation(extent={{-66,-48},{-52,-34}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,-50})));
  Components.PCMtank_hA PCMtank(
    redeclare package Medium = MediumA,
    m_flow_nominal=0.1,
    dp_nominal=500,
    nTub=4,
    Rmax=0.05,
    Ro=0.045,
    Ri=0.043,
    L=4,
    PCM_t_ini=287.15,
    m=330) annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  DHP.DXSystems.Both.WaterSource.VariableSpeedReversible2 heaPum(
    datCoi=datCoiCoo,
    datCoiHea=datCoiHea,
    redeclare package MediumEva = MediumA,
    redeclare package MediumCon = MediumW,
    dpEva_nominal=dpEva_nominal,
    dpCon_nominal=dpCon_nominal,
    minSpeRat=0.31) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/Atlanta_SingleFamily_CZ3A_IECC_2021_ideal_hvac_v96.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_GA_Atlanta-Hartsfield-Jackson.Intl.AP.722190_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_GA_Atlanta-Hartsfield-Jackson.Intl.AP.722190_TMY3.mos"),
    usePrecompiledFMU=false,
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="living_unit1",
    redeclare package Medium = MediumA,
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{80,30},{120,70}})));
  Modelica.Blocks.Sources.Constant qIntGai[2](each k=0)
    "Internal heat gains, set to zero because these are modeled in EnergyPlus"
    annotation (Placement(transformation(extent={{34,64},{46,76}})));
  Modelica.Blocks.Sources.CombiTimeTable q_internal(
    table=[0,166.789147; 900,208.7887643; 1800,208.7887643; 2700,202.580896; 3600,202.5803794; 4500,190.8937159; 5400,
        190.8936482; 6300,196.8954021; 7200,196.8963449; 8100,217.1794891; 9000,217.1794892; 9900,225.5097138; 10800,
        225.5121431; 11700,228.1554038; 12600,228.3200813; 13500,225.8956555; 14400,235.1467862; 15300,227.3309612;
        16200,227.3272539; 17100,241.3976499; 18000,256.5015995; 18900,229.2812688; 19800,229.2812688; 20700,239.8898214;
        21600,243.3754121; 22500,214.5309915; 23400,214.5309916; 24300,211.6049042; 25200,187.1857048; 26100,190.455247;
        27000,190.455247; 27900,182.7005691; 28800,83.87614367; 29700,91.91956479; 30600,91.91956479; 31500,79.48655682;
        32400,48.20277911; 33300,50.71302182; 34200,50.71302182; 35100,54.35562858; 36000,54.35562833; 36900,61.19121549;
        37800,61.19116136; 38700,65.24494368; 39600,65.24510611; 40500,60.91797752; 41400,60.91797752; 42300,54.05595623;
        43200,54.05595623; 44100,55.04804451; 45000,55.04804451; 45900,54.5936227; 46800,54.59314094; 47700,61.40767701;
        48600,61.407677; 49500,58.06206447; 50400,58.06206447; 51300,63.79201682; 52200,63.79201684; 53100,57.30956654;
        54000,63.69969713; 54900,68.11831489; 55800,68.11832463; 56700,68.55555433; 57600,97.7147386; 58500,105.1638147;
        59400,105.1638147; 60300,100.0392505; 61200,171.8915894; 62100,168.8751286; 63000,168.8751286; 63900,169.5643145;
        64800,262.4896985; 65700,284.8134051; 66600,284.8126728; 67500,267.8337841; 68400,274.435519; 69300,262.93248;
        70200,262.9324795; 71100,243.9166757; 72000,243.9166757; 72900,244.7562438; 73800,244.7562438; 74700,252.2400266;
        75600,256.9809891; 76500,270.2774873; 77400,270.2770779; 78300,294.0025752; 79200,271.3412636; 80100,247.4794838;
        81000,247.4795324; 81900,237.1276197; 82800,220.2808827; 83700,191.2302529; 84600,191.2302529; 85500,173.7602022],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=15984000)                             annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Modelica.Blocks.Math.Gain gain(k=1/220) annotation (Placement(transformation(extent={{34,84},{46,96}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium = MediumA, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  DHP.Fluid.ThreeWayValves.ThreeWay13in2out valSup(
    redeclare package Medium = MediumA,
    m_flow_nominal_12=m_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                                                  annotation (Placement(transformation(extent={{16,-6},{28,6}})));
  DHP.Fluid.ThreeWayValves.ThreeWay23in1out valRet(
    redeclare package Medium = MediumA,
    m_flow_nominal_12=m_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{26,-74},{14,-86}})));
  parameter DHP.DXSystems.Both.WaterSource.Data.VSV024Hea2
                            datCoiHea annotation (Placement(transformation(extent={{80,80},{100,100}})));
  parameter DHP.DXSystems.Both.WaterSource.Data.VSV024Coo2
                            datCoiCoo annotation (Placement(transformation(extent={{100,80},{120,100}})));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa") = 500
    "Pressure difference over evaporator at nominal flow rate";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa") = 3000
    "Pressure difference over condenser at nominal flow rate";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(displayUnit="Pa") = 0;
  Modelica.Blocks.Interfaces.RealInput u[4] annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-200,60},{-160,100}})));
  Modelica.Blocks.Interfaces.RealOutput Troo annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Modelica.Blocks.Interfaces.RealOutput SOC annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Modelica.Blocks.Interfaces.RealOutput QheaPum annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Modelica.Blocks.Interfaces.RealOutput PheaPum annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Components.modSwi modSwi annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Continuous.FirstOrder fil[4](T=1)
    annotation (Placement(transformation(extent={{-146,74},{-134,86}})));
  Modelica.Blocks.Math.RealToInteger reaToInt[4]
    annotation (Placement(transformation(extent={{-126,74},{-114,86}})));
  Modelica.Blocks.Sources.RealExpression zonAirT(y=zon.heaPorAir.T)
    annotation (Placement(transformation(extent={{130,20},{150,40}})));
  Modelica.Blocks.Sources.RealExpression tanSOC(y=PCMtank.Phi)
    annotation (Placement(transformation(extent={{130,0},{150,20}})));
  Modelica.Blocks.Sources.RealExpression heaRat(y=heaPum.QEvaSen_flow + heaPum.QEvaLat_flow)
    annotation (Placement(transformation(extent={{130,-20},{150,0}})));
  Modelica.Blocks.Sources.RealExpression heaPow(y=heaPum.P)
    annotation (Placement(transformation(extent={{130,-40},{150,-20}})));
equation
  connect(qIntGai[1].y,zon. qGai_flow[1])
    annotation (Line(points={{46.6,70},{60,70},{60,59.3333},{78,59.3333}},  color={0,0,127}));
  connect(qIntGai[2].y,zon. qGai_flow[3])
    annotation (Line(points={{46.6,70},{60,70},{60,60.6667},{78,60.6667}},color={0,0,127}));
  connect(q_internal.y[1], gain.u) annotation (Line(points={{21,90},{32.8,90}}, color={0,0,127}));
  connect(PCMtank.port_b, valRet.port_3) annotation (Line(
      points={{30,-40},{40,-40},{40,-62},{20,-62},{20,-74}},
      color={0,128,255},
      thickness=1));
  connect(valSup.port_3, PCMtank.port_a) annotation (Line(
      points={{22,-6},{22,-22},{0,-22},{0,-40},{10,-40}},
      color={0,128,255},
      thickness=1));
  connect(sou.ports[1], heaPum.portCon_a)
    annotation (Line(points={{-52,-59},{-52,-60},{-24,-60},{-24,-10}},
                                                             color={170,170,255},
      thickness=0.5));
  connect(heaPum.port_b, valSup.port_1)
    annotation (Line(
      points={{-20,0},{16,0}},
      color={0,212,0},
      thickness=1));
  connect(heaPum.port_a, valRet.port_2)
    annotation (Line(
      points={{-40,0},{-100,0},{-100,-80},{14,-80}},
      color={0,212,0},
      thickness=1));
  connect(res.port_a, fan.port_a)
    annotation (Line(
      points={{100,-60},{100,-80},{80,-80}},
      color={0,212,0},
      thickness=1));
  connect(valRet.port_1, fan.port_b)
    annotation (Line(
      points={{26,-80},{60,-80}},
      color={0,212,0},
      thickness=1));
  connect(valSup.port_2, zon.ports[1])
    annotation (Line(
      points={{28,0},{99,0},{99,30.9}},
      color={0,212,0},
      thickness=1));
  connect(res.port_b, zon.ports[2])
    annotation (Line(
      points={{100,-40},{100,30.9},{101,30.9}},
      color={0,212,0},
      thickness=1));
  connect(u, fil.u) annotation (Line(points={{-180,80},{-147.2,80}}, color={0,0,127}));
  connect(fil.y, reaToInt.u) annotation (Line(points={{-133.4,80},{-127.2,80}}, color={0,0,127}));
  connect(reaToInt.y, modSwi.u) annotation (Line(points={{-113.4,80},{-102,80}}, color={255,127,0}));
  connect(heaPum.portCon_b, bou.ports[1])
    annotation (Line(
      points={{-36,-10},{-36,-41},{-52,-41}},
      color={255,0,0},
      thickness=0.5));
  connect(modSwi.yHeaPum, heaPum.speRat) annotation (Line(
      points={{-79,78},{-48,78},{-48,8},{-41.2,8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(modSwi.yVal, valSup.u) annotation (Line(
      points={{-79,86},{-40,86},{-40,40},{22,40},{22,7.2}},
      color={255,127,0},
      pattern=LinePattern.Dash));
  connect(modSwi.yVal, valRet.u) annotation (Line(
      points={{-79,86},{-40,86},{-40,40},{-10,40},{-10,-96},{20,-96},{20,-87.2}},
      color={255,127,0},
      pattern=LinePattern.Dash));
  connect(modSwi.heaPumOnOff, heaPum.uMod) annotation (Line(
      points={{-79,82},{-44,82},{-44,-20},{-30,-20},{-30,-11}},
      color={255,127,0},
      pattern=LinePattern.Dash));
  connect(modSwi.yFan, fan.m_flow_in) annotation (Line(
      points={{-79,74},{-52,74},{-52,30},{70,30},{70,-68}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gain.y, zon.qGai_flow[2]) annotation (Line(points={{46.6,90},{60,90},{60,60},{78,60}}, color={0,0,127}));
  connect(Troo, zonAirT.y) annotation (Line(points={{170,30},{151,30}}, color={0,0,127}));
  connect(tanSOC.y, SOC) annotation (Line(points={{151,10},{170,10}}, color={0,0,127}));
  connect(heaRat.y, QheaPum) annotation (Line(points={{151,-10},{170,-10}}, color={0,0,127}));
  connect(heaPow.y, PheaPum) annotation (Line(points={{151,-30},{170,-30}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})),
                                                               Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})),
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
end hpTesMPC;
