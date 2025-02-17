within slPCMlib.Components.RadiantSlabs.Examples;
model RadiantHeatingCooling_TRoom
  "Example model with one thermal zone with a radiant floor where the cooling is controlled based on the room air temperature"
  extends slPCMlib.Components.RadiantSlabs.BaseClasses.FloorComplete(T_start=
        296.15,                                                      building(
      idfName=idfName,
      epwName=epwName,
      weaName=weaName));
  package MediumW=Buildings.Media.Water
    "Water medium";
  package MediumG=Buildings.Media.Antifreeze.EthyleneGlycolWater(property_T=293.15, X_a=0.40)
    "Water glycol";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_GA_Atlanta-Hartsfield-Jackson.Intl.AP.722190_TMY3.mos")
    "Name of the weather file";
  parameter String epwName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_GA_Atlanta-Hartsfield-Jackson.Intl.AP.722190_TMY3.epw")
    "Name of the weather file";
  parameter String idfName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/ASHRAE901_OfficeSmall_STD2004_Atlanta_IdealLoadSystem_updated_v96.idf")
    "Name of the weather file";

//   constant Modelica.Units.SI.Area AFlo=185.8 "Floor area";
//   parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=8000
//     "Nominal heat flow rate for heating";
//   parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
//       4200/10 "Design water mass flow rate for heating";
//   parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-5000
//     "Nominal heat flow rate for cooling";
//   parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal
//       /4200/5 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal=1.5*(designPar.mCoo_flow_nominal_Sou
       + designPar.mCoo_flow_nominal_Eas + designPar.mCoo_flow_nominal_Nor +
      designPar.mCoo_flow_nominal_Wes + designPar.mCoo_flow_nominal_Cor)*(1 - 1
      /4)*4200/3500
   "Design water mass flow rate for heating";
  // Floor slab
  // Ceiling slab
  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCeiSou(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=PERClayCei,
    iLayPip=2,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=designPar.Radiant_loop_spacing,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=sou.AFlo,
    m_flow_nominal=designPar.mCoo_flow_nominal_Sou,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=designPar.PCM_thickness,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{622,212},{642,232}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,214},{602,234}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFlo(surfaceName="Attic_floor_perimeter_south")
    "Floor of the attic above the living room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={722,224})));

//initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  //assert(
    //abs(
      //AFlo-zon.AFlo) < 0.1,
    //"Floor area AFlo differs from EnergyPlus floor area.");

  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCeiNor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=PERClayCei,
    iLayPip=2,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=designPar.Radiant_loop_spacing,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=nor.AFlo,
    m_flow_nominal=designPar.mCoo_flow_nominal_Nor,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=designPar.PCM_thickness,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{622,94},{642,114}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo1(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,94},{602,114}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloNor(surfaceName="Attic_floor_perimeter_north")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,104})));
  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCeiEas(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=PERClayCei,
    iLayPip=2,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=designPar.Radiant_loop_spacing,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=eas.AFlo,
    m_flow_nominal=designPar.mCoo_flow_nominal_Eas,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=designPar.PCM_thickness,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{622,154},{642,174}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo2(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,154},{602,174}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloEas(surfaceName="Attic_floor_perimeter_east")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,164})));
  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCeiWes(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=PERClayCei,
    iLayPip=2,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=designPar.Radiant_loop_spacing,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=wes.AFlo,
    m_flow_nominal=designPar.mCoo_flow_nominal_Wes,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=designPar.PCM_thickness,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{622,34},{642,54}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo3(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,34},{602,54}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloWes(surfaceName="Attic_floor_perimeter_west")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,44})));
  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCeiCor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=PERClayCei_Cor,
    iLayPip=1,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=designPar.Radiant_loop_spacing,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=cor.AFlo,
    m_flow_nominal=designPar.mCoo_flow_nominal_Cor,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=designPar.PCM_thickness,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{622,-26},{642,-6}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo4(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,-26},{602,-6}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloCor(surfaceName="Core_ZN_ceiling")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,-16})));
  Modelica.Blocks.Routing.DeMultiplex demux_TRoo(n=5)
    annotation (Placement(transformation(extent={{400,210},{420,230}})));
  Modelica.Blocks.Routing.DeMultiplex demux_PhiRoo(n=5)
    annotation (Placement(transformation(extent={{400,180},{420,200}})));
  BaseClasses.DesignPar designPar(
    QCoo_flow_nominal_Sou=-5000,
    QCoo_flow_nominal_Eas=-4000,
    QCoo_flow_nominal_Nor=-5000,
    QCoo_flow_nominal_Wes=-4500,
    QCoo_flow_nominal_Cor=-5000,
    Radiant_loop_spacing=0.1,
    PCM_thickness=0.02)          annotation (Placement(transformation(extent={{800,340},
            {820,360}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic PERClayCei(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{760,340},{780,360}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic PERClayCei_Cor(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.02),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
         0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08)})
                "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{720,340},{740,360}})));
  parameter Modelica.Units.SI.Temperature T_cons_start=291.65
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false";
  BaseClasses.Controller_T conCoo_sou(
    mRadWatSup=designPar.mCoo_flow_nominal_Sou,
    TSupSet_max=291.15,
    TSupSet_min=285.15,
    TSetZone=TSetZone)
    annotation (Placement(transformation(extent={{480,240},{500,260}})));
  BaseClasses.Controller_T conCoo_eas(
    mRadWatSup=designPar.mCoo_flow_nominal_Eas,
    TSupSet_max=291.15,
    TSupSet_min=285.15,
    TSetZone=TSetZone)
    annotation (Placement(transformation(extent={{480,180},{500,200}})));
  BaseClasses.Controller_T conCoo_nor(
    mRadWatSup=designPar.mCoo_flow_nominal_Nor,
    TSupSet_max=291.15,
    TSupSet_min=285.15,
    TSetZone=TSetZone)
    annotation (Placement(transformation(extent={{480,120},{500,140}})));
  BaseClasses.Controller_T conCoo_wes(
    mRadWatSup=designPar.mCoo_flow_nominal_Wes,
    TSupSet_max=291.15,
    TSupSet_min=285.15,
    TSetZone=TSetZone)
    annotation (Placement(transformation(extent={{480,60},{500,80}})));
  BaseClasses.Controller_T conCoo_cor(
    mRadWatSup=designPar.mCoo_flow_nominal_Cor,
    TSupSet_max=291.15,
    TSupSet_min=285.15,
    TSetZone=TSetZone)
    annotation (Placement(transformation(extent={{480,0},{500,20}})));
  parameter Modelica.Units.SI.Temperature TSetZone=297.65 "Constant output value";
  Modelica.Blocks.Sources.RealExpression QCon(y=-heaPum.QEva_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{860,40},{880,60}})));
  Modelica.Blocks.Sources.RealExpression PEle(y=heaPum.P + pumBor.P + (
        slaCeiSou.dp*slaCeiSou.m_flow/1000/0.75 + slaCeiEas.dp*slaCeiEas.m_flow
        /1000/0.75 + slaCeiNor.dp*slaCeiNor.m_flow/1000/0.75 + slaCeiWes.dp*
        slaCeiWes.m_flow/1000/0.75 + slaCeiCor.dp*slaCeiCor.m_flow/1000/0.75))
    "Electricity use"
    annotation (Placement(transformation(extent={{860,2},{880,22}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k(final unit="1/m2"),
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(final unit="W"),
    y(final unit="J/m2", displayUnit="kW.h/m2"))
    "Produced heat per unit area of floor"
    annotation (Placement(transformation(extent={{900,40},{920,60}})));
  Modelica.Blocks.Continuous.Integrator EEle(
    k(final unit="1/m2"),
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=1E-10,
    u(final unit="W"),
    y(final unit="J/m2", displayUnit="kW.h/m2"))
    "Electricity use per floor area"
    annotation (Placement(transformation(extent={{900,2},{920,22}})));
  Buildings.Controls.OBC.CDL.Reals.Divide COP "Coefficient of performance"
    annotation (Placement(transformation(extent={{940,20},{960,40}})));
  Modelica.Blocks.Sources.RealExpression PEleCirPum(y=(slaCeiSou.dp*slaCeiSou.m_flow
        /1000/0.75 + slaCeiEas.dp*slaCeiEas.m_flow/1000/0.75 + slaCeiNor.dp*
        slaCeiNor.m_flow/1000/0.75 + slaCeiWes.dp*slaCeiWes.m_flow/1000/0.75 +
        slaCeiCor.dp*slaCeiCor.m_flow/1000/0.75)) "Electricity use"
    annotation (Placement(transformation(extent={{860,100},{880,120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_Sou(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_Sou) "Water supply temperature"
    annotation (Placement(transformation(extent={{652,212},{672,232}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_Eas(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_Eas) "Water supply temperature"
    annotation (Placement(transformation(extent={{650,154},{670,174}})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={designPar.mCoo_flow_nominal_Sou,designPar.mCoo_flow_nominal_Eas,
        -designPar.mCoo_flow_nominal_Sou - designPar.mCoo_flow_nominal_Eas},
    dp_nominal={0,0,0})                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={690,164})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_Nor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_Nor) "Water supply temperature"
    annotation (Placement(transformation(extent={{650,94},{670,114}})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={designPar.mCoo_flow_nominal_Sou + designPar.mCoo_flow_nominal_Eas,
        designPar.mCoo_flow_nominal_Nor,-designPar.mCoo_flow_nominal_Sou -
        designPar.mCoo_flow_nominal_Eas - designPar.mCoo_flow_nominal_Nor},
    dp_nominal={0,0,0})                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={690,104})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_Wes(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_Wes) "Water supply temperature"
    annotation (Placement(transformation(extent={{650,34},{670,54}})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={designPar.mCoo_flow_nominal_Sou + designPar.mCoo_flow_nominal_Eas
         + designPar.mCoo_flow_nominal_Nor,designPar.mCoo_flow_nominal_Wes,-
        designPar.mCoo_flow_nominal_Sou - designPar.mCoo_flow_nominal_Eas -
        designPar.mCoo_flow_nominal_Nor - designPar.mCoo_flow_nominal_Wes},
    dp_nominal={0,0,0})                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={690,44})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_Cor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_Cor) "Water supply temperature"
    annotation (Placement(transformation(extent={{650,-26},{670,-6}})));
  Buildings.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={designPar.mCoo_flow_nominal_Sou + designPar.mCoo_flow_nominal_Eas
         + designPar.mCoo_flow_nominal_Nor + designPar.mCoo_flow_nominal_Wes,
        designPar.mCoo_flow_nominal_Cor,-designPar.mCoo_flow_nominal_Sou -
        designPar.mCoo_flow_nominal_Eas - designPar.mCoo_flow_nominal_Nor -
        designPar.mCoo_flow_nominal_Wes - designPar.mCoo_flow_nominal_Cor},
    dp_nominal={0,0,0})                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={690,-16})));
  Buildings.Fluid.HeatPumps.ScrollWaterToWater heaPum(
    redeclare package Medium1 = MediumG,
    redeclare package Medium2 = MediumW,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mBor_flow_nominal,
    m2_flow_nominal=designPar.mCoo_flow_nominal_sys,
    show_T=true,
    dp1_nominal=10000,
    dp2_nominal=10000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    enable_temperature_protection=false,
    datHeaPum=
        Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating.Viessmann_BW301A21_28kW_5_94COP_R410A())
    "Heat pump" annotation (Placement(transformation(extent={{750,-122},{730,-142}})));
 Buildings.Fluid.Geothermal.Boreholes.UTube borHol(
    redeclare package Medium = MediumG,
    hBor=150,
    dp_nominal=60000,
    TExt0_start=291.15,
    dT_dz=0.0015,
    samplePeriod=604800,
    m_flow_nominal=mBor_flow_nominal/2,
    redeclare parameter Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite
      matFil,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{632,-210},{652,-190}})));
  Buildings.Fluid.Sources.Boundary_ph preSou(
    redeclare package Medium = MediumG,
    p(displayUnit="Pa") = 300000,
    nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{540,-148},{560,-128}})));
  Modelica.Blocks.Math.MinMax temSetMin(nu=5)
    annotation (Placement(transformation(extent={{540,-70},{520,-50}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conSup(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=4,
    Ti(displayUnit="min") = 60,
    r=10,
    yMax=1,
    yMin=0.1,
    reverseActing=false,
    y_reset=0.1) "Controller for heat pump" annotation (Placement(transformation(extent={{600,-80},
            {620,-60}})));
  Modelica.Blocks.MathBoolean.Or onBorHol(nu=5)
    annotation (Placement(transformation(extent={{540,-118},{560,-98}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaBorHol(realTrue=1)
           "Cooling water mass flow rate"
    annotation (Placement(transformation(extent={{650,-130},{670,-110}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumBor(
    redeclare package Medium = MediumG,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(
      pressure(V_flow=2*{0,mBor_flow_nominal}/1000, dp=2*{60000 + 10000,0}),
      speed_nominal,
      constantSpeed,
      speeds),
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Pump"
    annotation (Placement(transformation(extent={{702,-176},{722,-156}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRet_heaPum(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=designPar.mCoo_flow_nominal_sys) "Water supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={690,-50})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiPum "Switch for circulation pumps"
    annotation (Placement(transformation(extent={{650,-88},{670,-68}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant off(final k=0) "Output 0 to switch heater off"
    annotation (Placement(transformation(extent={{620,-54},{634,-40}})));
 Buildings.Fluid.Geothermal.Boreholes.UTube borHol1(
    redeclare package Medium = MediumG,
    hBor=150,
    dp_nominal=60000,
    TExt0_start=291.15,
    dT_dz=0.0015,
    samplePeriod=604800,
    m_flow_nominal=mBor_flow_nominal/2,
    redeclare parameter Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite
      matFil,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{632,-176},{652,-156}})));
  Buildings.Fluid.FixedResistances.Junction jun4(
    redeclare package Medium = MediumG,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={mBor_flow_nominal,-mBor_flow_nominal/2,-mBor_flow_nominal/2},
    dp_nominal={0,0,0})                          annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={606,-166})));
  Buildings.Fluid.FixedResistances.Junction jun5(
    redeclare package Medium = MediumG,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={mBor_flow_nominal/2,mBor_flow_nominal/2,-mBor_flow_nominal},
    dp_nominal={0,0,0})                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={680,-166})));
  Modelica.Blocks.Math.MinMax temDewMin(nu=5)
    annotation (Placement(transformation(extent={{440,-112},{460,-92}})));
  Modelica.Blocks.Sources.RealExpression temDewSou(y(
      final unit="K",
      displayUnit="degC") = conCoo_sou.conCoo.dewPoi.TDewPoi)
    annotation (Placement(transformation(extent={{380,-68},{400,-48}})));
  Modelica.Blocks.Sources.RealExpression temDewSou1(y(
      final unit="K",
      displayUnit="degC") = conCoo_eas.conCoo.dewPoi.TDewPoi)
    annotation (Placement(transformation(extent={{380,-88},{400,-68}})));
  Modelica.Blocks.Sources.RealExpression temDewSou2(y(
      final unit="K",
      displayUnit="degC") = conCoo_nor.conCoo.dewPoi.TDewPoi)
    annotation (Placement(transformation(extent={{380,-108},{400,-88}})));
  Modelica.Blocks.Sources.RealExpression temDewSou3(y(
      final unit="K",
      displayUnit="degC") = conCoo_wes.conCoo.dewPoi.TDewPoi)
    annotation (Placement(transformation(extent={{380,-128},{400,-108}})));
  Modelica.Blocks.Sources.RealExpression temDewSou4(y(
      final unit="K",
      displayUnit="degC") = conCoo_cor.conCoo.dewPoi.TDewPoi)
    annotation (Placement(transformation(extent={{380,-148},{400,-128}})));
  Buildings.Controls.OBC.CDL.Reals.Max setPoiHeaPum
    annotation (Placement(transformation(extent={{480,-100},{500,-80}})));
  Buildings.Fluid.Sources.Boundary_ph preLoa(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{820,-136},{800,-116}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSup_heaPum(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=(designPar.mCoo_flow_nominal_Sou + designPar.mCoo_flow_nominal_Eas
         + designPar.mCoo_flow_nominal_Nor + designPar.mCoo_flow_nominal_Wes +
        designPar.mCoo_flow_nominal_Cor),
    tau=0,
    transferHeat=true) "Water supply temperature"
    annotation (Placement(transformation(extent={{770,-136},{790,-116}})));
  Modelica.Blocks.Sources.RealExpression PEle_TOU(y=(heaPum.P + pumBor.P + (
        slaCeiSou.dp*slaCeiSou.m_flow/1000/0.75 + slaCeiEas.dp*slaCeiEas.m_flow
        /1000/0.75 + slaCeiNor.dp*slaCeiNor.m_flow/1000/0.75 + slaCeiWes.dp*
        slaCeiWes.m_flow/1000/0.75 + slaCeiCor.dp*slaCeiCor.m_flow/1000/0.75))*
        TOU_Atlanta.y[1])      "Electricity use"
    annotation (Placement(transformation(extent={{860,130},{880,150}})));
  Modelica.Blocks.Continuous.Integrator ECost_TOU(k(final unit="1/m2") = 1/3600
      /1000, initType=Modelica.Blocks.Types.Init.InitialState)
    "Electricity use per floor area"
    annotation (Placement(transformation(extent={{900,130},{920,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TOU_Atlanta(table=[0,
        0.115925; 14,0.115925; 14,0.24555; 19,0.24555; 19,0.115925; 24,0.115925],
      timeScale=3600) "Load shifting schedule, true if normal operation mode"
    annotation (Placement(transformation(extent={{860,160},{880,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TOU_Atlanta1(table=[0,0.021859; 7,0.021859; 7,0.10167; 14,
        0.10167; 14,0.297868; 19,0.297868; 19,0.10167; 23,0.10167; 23,0.021859; 24,0.021859], timeScale=3600)
                      "Load shifting schedule, true if normal operation mode"
    annotation (Placement(transformation(extent={{900,160},{920,180}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant phi_Zon[5](k=0.5)
    "Internal heat gain (computed already in EnergyPlus)"
    annotation (Placement(transformation(extent={{366,180},{386,200}})));
equation
  connect(masFloSouCoo.ports[1], slaCeiSou.port_a) annotation (Line(points={{602,224},{612,224},{612,222},{622,222}},
                                                                                                color={0,127,255}));
  connect(attFlo.heaPorFro, slaCeiSou.surf_a)
    annotation (Line(points={{722,234},{722,244},{636,244},{636,232}},
                                                                   color={191,0,0}));
  connect(slaCeiSou.surf_b, attFlo.heaPorBac)
    annotation (Line(points={{636,212},{636,204},{722,204},{722,214.2}},
                                                                   color={191,0,0}));
  connect(masFloSouCoo1.ports[1], slaCeiNor.port_a)
    annotation (Line(points={{602,104},{622,104}}, color={0,127,255}));
  connect(attFloNor.heaPorFro, slaCeiNor.surf_a)
    annotation (Line(points={{722,114},{722,124},{636,124},{636,114}}, color={191,0,0}));
  connect(slaCeiNor.surf_b, attFloNor.heaPorBac)
    annotation (Line(points={{636,94},{636,84},{722,84},{722,94.2}},         color={191,0,0}));
  connect(masFloSouCoo2.ports[1], slaCeiEas.port_a)
    annotation (Line(points={{602,164},{622,164}}, color={0,127,255}));
  connect(attFloEas.heaPorFro, slaCeiEas.surf_a)
    annotation (Line(points={{722,174},{722,184},{636,184},{636,174}}, color={191,0,0}));
  connect(slaCeiEas.surf_b, attFloEas.heaPorBac)
    annotation (Line(points={{636,154},{636,144},{722,144},{722,154.2}}, color={191,0,0}));
  connect(masFloSouCoo3.ports[1], slaCeiWes.port_a)
    annotation (Line(points={{602,44},{622,44}},     color={0,127,255}));
  connect(attFloWes.heaPorFro, slaCeiWes.surf_a)
    annotation (Line(points={{722,54},{722,64},{636,64},{636,54}},         color={191,0,0}));
  connect(slaCeiWes.surf_b, attFloWes.heaPorBac)
    annotation (Line(points={{636,34},{636,24},{722,24},{722,34.2}},         color={191,0,0}));
  connect(masFloSouCoo4.ports[1], slaCeiCor.port_a)
    annotation (Line(points={{602,-16},{622,-16}},   color={0,127,255}));
  connect(slaCeiCor.surf_a, attFloCor.heaPorFro)
    annotation (Line(points={{636,-6},{636,4},{722,4},{722,-6}},           color={191,0,0}));
  connect(slaCeiCor.surf_b, attFloCor.heaPorBac)
    annotation (Line(points={{636,-26},{636,-36},{722,-36},{722,-25.8}},     color={191,0,0}));
  connect(phi_Zon.y, demux_PhiRoo.u) annotation (Line(points={{388,190},{398,190}}, color={0,0,127}));
  connect(TOpe.y, demux_TRoo.u) annotation (Line(points={{361,430},{370,430},{
          370,220},{398,220}}, color={0,0,127}));
  connect(conCoo_sou.mWatSup, masFloSouCoo.m_flow_in) annotation (Line(points={
          {501,245},{572,245},{572,232},{580,232}}, color={0,0,127}));
  connect(conCoo_eas.mWatSup, masFloSouCoo2.m_flow_in) annotation (Line(points=
          {{501,185},{572,185},{572,172},{580,172}}, color={0,0,127}));
  connect(conCoo_nor.mWatSup, masFloSouCoo1.m_flow_in) annotation (Line(points=
          {{501,125},{572,125},{572,112},{580,112}}, color={0,0,127}));
  connect(conCoo_wes.mWatSup, masFloSouCoo3.m_flow_in) annotation (Line(points=
          {{501,65},{572,65},{572,52},{580,52}}, color={0,0,127}));
  connect(conCoo_cor.mWatSup, masFloSouCoo4.m_flow_in) annotation (Line(points=
          {{501,5},{572,5},{572,-8},{580,-8}}, color={0,0,127}));
  connect(demux_PhiRoo.y[1], conCoo_sou.phiZon) annotation (Line(points={{420,
          187.2},{472,187.2},{472,242},{478,242}}, color={0,0,127}));
  connect(demux_PhiRoo.y[2], conCoo_eas.phiZon) annotation (Line(points={{420,
          188.6},{424,188.6},{424,188},{472,188},{472,182},{478,182}}, color={0,
          0,127}));
  connect(demux_PhiRoo.y[3], conCoo_nor.phiZon) annotation (Line(points={{420,
          190},{424,190},{424,188},{472,188},{472,122},{478,122}}, color={0,0,
          127}));
  connect(demux_PhiRoo.y[4], conCoo_wes.phiZon) annotation (Line(points={{420,
          191.4},{424,191.4},{424,188},{472,188},{472,62},{478,62}}, color={0,0,
          127}));
  connect(demux_PhiRoo.y[5], conCoo_cor.phiZon) annotation (Line(points={{420,
          192.8},{424,192.8},{424,188},{472,188},{472,2},{478,2}}, color={0,0,
          127}));
  connect(demux_TRoo.y[1], conCoo_sou.temZon) annotation (Line(points={{420,
          217.2},{468,217.2},{468,256},{478,256}}, color={0,0,127}));
  connect(demux_TRoo.y[2], conCoo_eas.temZon) annotation (Line(points={{420,
          218.6},{468,218.6},{468,196},{478,196}}, color={0,0,127}));
  connect(demux_TRoo.y[3], conCoo_nor.temZon) annotation (Line(points={{420,220},
          {424,220},{424,216},{468,216},{468,136},{478,136}}, color={0,0,127}));
  connect(demux_TRoo.y[4], conCoo_wes.temZon) annotation (Line(points={{420,
          221.4},{424,221.4},{424,216},{468,216},{468,76},{478,76}}, color={0,0,
          127}));
  connect(demux_TRoo.y[5], conCoo_cor.temZon) annotation (Line(points={{420,
          222.8},{424,222.8},{424,216},{468,216},{468,16},{478,16}}, color={0,0,
          127}));
  connect(EHea.u,QCon. y)
    annotation (Line(points={{898,50},{881,50}},     color={0,0,127}));
  connect(EEle.u, PEle.y)
    annotation (Line(points={{898,12},{881,12}}, color={0,0,127}));
  connect(EEle.y,COP. u2) annotation (Line(points={{921,12},{928,12},{928,24},{938,
          24}},        color={0,0,127}));
  connect(EHea.y,COP. u1) annotation (Line(points={{921,50},{930,50},{930,36},{938,
          36}},        color={0,0,127}));
  connect(slaCeiSou.port_b, senTemRet_Sou.port_a)
    annotation (Line(points={{642,222},{652,222}}, color={0,127,255}));
  connect(senTemRet_Eas.port_a, slaCeiEas.port_b)
    annotation (Line(points={{650,164},{642,164}}, color={0,127,255}));
  connect(senTemRet_Sou.port_b,jun. port_1) annotation (Line(points={{672,222},{
          690,222},{690,174}}, color={0,127,255}));
  connect(senTemRet_Eas.port_b,jun. port_3)
    annotation (Line(points={{670,164},{680,164}}, color={0,127,255}));
  connect(jun.port_2,jun1. port_1)
    annotation (Line(points={{690,154},{690,114}}, color={0,127,255}));
  connect(senTemRet_Nor.port_b,jun1. port_3)
    annotation (Line(points={{670,104},{680,104}}, color={0,127,255}));
  connect(slaCeiNor.port_b, senTemRet_Nor.port_a)
    annotation (Line(points={{642,104},{650,104}}, color={0,127,255}));
  connect(senTemRet_Wes.port_a, slaCeiWes.port_b)
    annotation (Line(points={{650,44},{642,44}}, color={0,127,255}));
  connect(senTemRet_Wes.port_b,jun2. port_3)
    annotation (Line(points={{670,44},{680,44}}, color={0,127,255}));
  connect(jun1.port_2,jun2. port_1)
    annotation (Line(points={{690,94},{690,54}}, color={0,127,255}));
  connect(senTemRet_Cor.port_a, slaCeiCor.port_b)
    annotation (Line(points={{650,-16},{642,-16}}, color={0,127,255}));
  connect(senTemRet_Cor.port_b,jun3. port_3)
    annotation (Line(points={{670,-16},{680,-16}}, color={0,127,255}));
  connect(jun2.port_2,jun3. port_1)
    annotation (Line(points={{690,34},{690,-6}}, color={0,127,255}));
  connect(senTemSup_heaPum.T,conSup. u_m)
    annotation (Line(points={{780,-115},{780,-104},{610,-104},{610,-82}},
                                                   color={0,0,127}));
  connect(onBorHol.y,booToReaBorHol. u)
    annotation (Line(points={{561.5,-108},{632,-108},{632,-120},{648,-120}},
                                                     color={255,0,255}));
  connect(pumBor.port_b,heaPum. port_a1) annotation (Line(points={{722,-166},{760,
          -166},{760,-138},{750,-138}},   color={0,127,255}));
  connect(booToReaBorHol.y,pumBor. y)
    annotation (Line(points={{672,-120},{712,-120},{712,-154}},
                                                             color={0,0,127}));
  connect(conSup.y,swiPum. u1) annotation (Line(points={{622,-70},{648,-70}},
                               color={0,0,127}));
  connect(off.y,swiPum. u3) annotation (Line(points={{635.4,-47},{638,-47},{638,
          -86},{648,-86}}, color={0,0,127}));
  connect(onBorHol.y,swiPum. u2) annotation (Line(points={{561.5,-108},{632,-108},
          {632,-78},{648,-78}},                     color={255,0,255}));
  connect(onBorHol.y,conSup. trigger) annotation (Line(points={{561.5,-108},{604,
          -108},{604,-82}},                    color={255,0,255}));
  connect(jun4.port_3,borHol1. port_a)
    annotation (Line(points={{616,-166},{632,-166}}, color={0,127,255}));
  connect(heaPum.port_b1,jun4. port_1) annotation (Line(points={{730,-138},{606,
          -138},{606,-156}},
                       color={0,127,255}));
  connect(jun4.port_2,borHol. port_a) annotation (Line(points={{606,-176},{606,-200},
          {632,-200}}, color={0,127,255}));
  connect(borHol1.port_b,jun5. port_1)
    annotation (Line(points={{652,-166},{670,-166}}, color={0,127,255}));
  connect(jun5.port_3,borHol. port_b) annotation (Line(points={{680,-176},{680,-200},
          {652,-200}}, color={0,127,255}));
  connect(jun5.port_2,pumBor. port_a)
    annotation (Line(points={{690,-166},{702,-166}}, color={0,127,255}));
  connect(heaPum.port_b1, preSou.ports[1])
    annotation (Line(points={{730,-138},{560,-138}}, color={0,127,255}));
  connect(temDewSou.y, temDewMin.u[1]) annotation (Line(points={{401,-58},{432,-58},
          {432,-104.8},{440,-104.8}}, color={0,0,127}));
  connect(temDewSou1.y, temDewMin.u[2]) annotation (Line(points={{401,-78},{432,
          -78},{432,-103.4},{440,-103.4}}, color={0,0,127}));
  connect(temDewSou2.y, temDewMin.u[3]) annotation (Line(points={{401,-98},{432,
          -98},{432,-102},{440,-102}}, color={0,0,127}));
  connect(temDewSou3.y, temDewMin.u[4]) annotation (Line(points={{401,-118},{432,
          -118},{432,-100.6},{440,-100.6}}, color={0,0,127}));
  connect(temDewSou4.y, temDewMin.u[5]) annotation (Line(points={{401,-138},{432,
          -138},{432,-99.2},{440,-99.2}}, color={0,0,127}));
  connect(setPoiHeaPum.y, conSup.u_s) annotation (Line(points={{502,-90},{592,-90},
          {592,-70},{598,-70}}, color={0,0,127}));
  connect(temDewMin.yMax, setPoiHeaPum.u2)
    annotation (Line(points={{461,-96},{478,-96}}, color={0,0,127}));
  connect(senTemRet_heaPum.port_b, heaPum.port_a2) annotation (Line(points={{690,
          -60},{690,-126},{730,-126}}, color={0,127,255}));
  connect(swiPum.y, heaPum.y) annotation (Line(points={{672,-78},{760,-78},{760,
          -135},{752,-135}}, color={0,0,127}));
  connect(setPoiHeaPum.y, masFloSouCoo4.T_in) annotation (Line(points={{502,-90},
          {592,-90},{592,-36},{568,-36},{568,-12},{580,-12}}, color={0,0,127}));
  connect(setPoiHeaPum.y, masFloSouCoo3.T_in) annotation (Line(points={{502,-90},
          {592,-90},{592,-36},{568,-36},{568,48},{580,48}}, color={0,0,127}));
  connect(setPoiHeaPum.y, masFloSouCoo1.T_in) annotation (Line(points={{502,-90},
          {592,-90},{592,-36},{568,-36},{568,108},{580,108}}, color={0,0,127}));
  connect(setPoiHeaPum.y, masFloSouCoo2.T_in) annotation (Line(points={{502,-90},
          {592,-90},{592,-36},{568,-36},{568,168},{580,168}}, color={0,0,127}));
  connect(setPoiHeaPum.y, masFloSouCoo.T_in) annotation (Line(points={{502,-90},
          {592,-90},{592,-36},{568,-36},{568,228},{580,228}}, color={0,0,127}));
  connect(jun3.port_2, senTemRet_heaPum.port_a)
    annotation (Line(points={{690,-26},{690,-40}}, color={0,127,255}));
  connect(heaPum.port_b2, senTemSup_heaPum.port_a)
    annotation (Line(points={{750,-126},{770,-126}}, color={0,127,255}));
  connect(senTemSup_heaPum.port_b, preLoa.ports[1])
    annotation (Line(points={{790,-126},{800,-126}}, color={0,127,255}));
  connect(temSetMin.yMin, setPoiHeaPum.u1) annotation (Line(points={{519,-66},{470,
          -66},{470,-84},{478,-84}}, color={0,0,127}));
  connect(conCoo_cor.TSetCoo, temSetMin.u[1]) annotation (Line(points={{501,15},
          {560,15},{560,-62.8},{540,-62.8}}, color={0,0,127}));
  connect(conCoo_wes.TSetCoo, temSetMin.u[2]) annotation (Line(points={{501,75},
          {560,75},{560,-61.4},{540,-61.4}}, color={0,0,127}));
  connect(conCoo_nor.TSetCoo, temSetMin.u[3]) annotation (Line(points={{501,135},
          {560,135},{560,-60},{540,-60}}, color={0,0,127}));
  connect(conCoo_eas.TSetCoo, temSetMin.u[4]) annotation (Line(points={{501,195},
          {560,195},{560,-58.6},{540,-58.6}}, color={0,0,127}));
  connect(conCoo_sou.TSetCoo, temSetMin.u[5]) annotation (Line(points={{501,255},
          {560,255},{560,-57.2},{540,-57.2}}, color={0,0,127}));
  connect(conCoo_cor.on, onBorHol.u[1]) annotation (Line(points={{502,8},{510,8},
          {510,-110.8},{540,-110.8}}, color={255,0,255}));
  connect(conCoo_wes.on, onBorHol.u[2]) annotation (Line(points={{502,68},{510,
          68},{510,-109.4},{540,-109.4}}, color={255,0,255}));
  connect(conCoo_nor.on, onBorHol.u[3]) annotation (Line(points={{502,128},{510,
          128},{510,-108},{540,-108}}, color={255,0,255}));
  connect(conCoo_eas.on, onBorHol.u[4]) annotation (Line(points={{502,188},{510,
          188},{510,-106.6},{540,-106.6}}, color={255,0,255}));
  connect(conCoo_sou.on, onBorHol.u[5]) annotation (Line(points={{502,248},{510,
          248},{510,-105.2},{540,-105.2}}, color={255,0,255}));
  connect(ECost_TOU.u,PEle_TOU. y)
    annotation (Line(points={{898,140},{881,140}},
                                                 color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingCooling_TRoom.mos" "Simulate and plot"),
    experiment(
      StartTime=20390400,
      StopTime=20995200,
      Interval=300,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus for the simulation of a building with one thermal zone
that has a radiant ceiling, used for cooling, and a radiant floor, used for heating.
The EnergyPlus model has one conditioned zone that is above ground. This conditioned zone
has an unconditioned attic.
The model is constructed by extending
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer</a>
and adding the radiant ceiling. For simplicity, this model provide heating with an idealized heater.
</p>
<p>
The next section explains how the radiant ceiling is configured.
</p>
<h4>Coupling of radiant ceiling to EnergyPlus model</h4>
<p>
The radiant ceiling is modeled in the instance <code>slaCei</code> at the top of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from the surface of the attic floor to the ceiling of the living room.
In this example, the construction is defined by the instance <code>layCei</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surfaces <code>slaCei.surf_a</code> (upward-facing) and
<code>slaCei.surf_a</code> (downward-facing)
are connected to the instance <code>attFlo</code>.
Because <code>attFlo</code> models the <em>floor</em> of the attic, rather than the ceiling
of the living room,
the heat port <code>slaCei.surf_a</code> is connected to <code>attFlo.heaPorFro</code>, which is the
front-facing surface, e.g., the floor.
Similarly,  <code>slaCei.surf_b</code> is connected to <code>attFlo.heaPorBac</code>, which is the
back-facing surface, e.g., the ceiling of the living room.
</p>
<p>
The mass flow rate of the slab is constant if the cooling is operating.
A P controller computes the control signal to track a set point for the room temperature.
The controller uses a hysteresis to switch the mass flow rate on or off.
The control signal is also used to set the set point for the water supply temperature to the slab.
This temperature is limited by the dew point of the zone air to avoid condensation.
</p>
<p>
See also the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface</a>
which is controlled to track a set point for the surface temperature.
</p>
<h4>Coupling of radiant floor to EnergyPlus model</h4>
<p>
The radiant floor is modeled in the instance <code>slaFlo</code> at the bottom of the schematic model view,
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
This instance models the heat transfer from surface of the floor to the lower surface of the slab.
In this example, the construction is defined by the instance <code>layFloSoi</code>.
(See the <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide</a>
for how to configure a radiant slab.)
In this example, the surfaces <code>slaFlo.surf_a</code> and
<code>slaFlo.surf_b</code>
are connected to the instance
<code>flo</code>.
In EnergyPlus, the surface <code>flo.heaPorBac</code> is connected
to the boundary condition of the soil because this building has no basement.
</p>
<p>
Note that the floor construction is modeled with <i>2</i> m of soil because the soil temperature
in EnergyPlus is assumed to be undisturbed.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 13, 2024, by Michael Wetter:<br/>
Updated <code>idf</code> file to add insulation, and resized system.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">issue 3707</a>.
</li>
<li>
December 1, 2022, by Michael Wetter:<br/>
Increased thickness of insulation of radiant slab and changed pipe spacing.
</li>
<li>
March 30, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-160,-120},{820,480}})),
    Icon(
      coordinateSystem(
        extent={{-160,-120},{820,480}})));
end RadiantHeatingCooling_TRoom;
