within slPCMlib.Components.RadiantSlabs.Examples;
model RadiantHeatingCooling_TRoom_Baseline
  "Example model with one thermal zone with a radiant floor where the cooling is controlled based on the room air temperature"
  extends slPCMlib.Components.RadiantSlabs.BaseClasses.FloorComplete(building(
      idfName=idfName,
      epwName=epwName,
      weaName=weaName));
  package MediumW=Buildings.Media.Water
    "Water medium";

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
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=8000
    "Nominal heat flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
      4200/10 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-5000
    "Nominal heat flow rate for cooling";
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal
      /4200/5 "Design water mass flow rate for heating";
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCeiSou(nLay=3, material={effIns,layPCM,
        gypSum}) "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{680,340},{700,360}})));
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
  Buildings.Fluid.Sources.Boundary_ph prePre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{694,214},{674,234}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,214},{602,234}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = 297.15, y(final unit="K", displayUnit="degC")) "Room temperture set point for cooling"
    annotation (Placement(transformation(extent={{400,240},{420,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSou(realTrue=designPar.mCoo_flow_nominal_Sou)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{540,222},{560,242}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFlo(surfaceName="Attic_floor_perimeter_south")
    "Floor of the attic above the living room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={722,224})));

  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo_sou(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{480,234},{500,254}})));
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
  Buildings.Fluid.Sources.Boundary_ph prePre1(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{694,94},{674,114}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo1(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,94},{602,114}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaNor(realTrue=designPar.mCoo_flow_nominal_Nor)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{540,102},{560,122}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloNor(surfaceName="Attic_floor_perimeter_north")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,104})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo_nor(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{480,114},{500,134}})));
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
  Buildings.Fluid.Sources.Boundary_ph prePre2(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{694,154},{674,174}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo2(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,154},{602,174}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaEas(realTrue=designPar.mCoo_flow_nominal_Eas)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{540,162},{560,182}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloEas(surfaceName="Attic_floor_perimeter_east")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,164})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo_eas(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{480,174},{500,194}})));
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
  Buildings.Fluid.Sources.Boundary_ph prePre3(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{694,34},{674,54}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo3(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,34},{602,54}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaWes(realTrue=designPar.mCoo_flow_nominal_Wes)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{540,42},{560,62}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloWes(surfaceName="Attic_floor_perimeter_west")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,44})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo_wes(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{480,54},{500,74}})));
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
  Buildings.Fluid.Sources.Boundary_ph prePre4(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{694,-26},{674,-6}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo4(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{582,-26},{602,-6}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaCor(realTrue=designPar.mCoo_flow_nominal_Cor)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{540,-18},{560,2}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloCor(surfaceName="Core_ZN_ceiling")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={722,-16})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo_cor(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{480,-6},{500,14}})));
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
    Radiant_loop_spacing=0.15,
    PCM_thickness=0.05)          annotation (Placement(transformation(extent={{520,340},{540,360}})));
  parameter Buildings.HeatTransfer.Data.Solids.GypsumBoard gypSum(x=0.016)
    annotation (Placement(transformation(extent={{640,340},{660,360}})));
  parameter Buildings.HeatTransfer.Data.Solids.Generic layPCM(
    x=0.02,
    k=0.2,
    c=2000.0,
    d=844.0)
    "layer thickness can range from 10-30 mm, now 20 mm. Accordingly, 5/8\" (15.9 mm) diameter pipe at 6\" spacing can be good practice. ATP18"
    annotation (Placement(transformation(extent={{620,340},{640,360}})));
  parameter Buildings.HeatTransfer.Data.Solids.InsulationBoard effIns(x=0.147)
    "To achieve the desired R-value with k=0.03, you need a thickness of approximately 0.147 m (147 mm)."
    annotation (Placement(transformation(extent={{600,340},{620,360}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCeiCor(nLay=3, material={gypSum,layPCM,
        effIns}) "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{700,340},{720,360}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic PERClayCei(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{460,340},{480,360}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic PERClayCei_Cor(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.02),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
         0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08)})
                "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{420,340},{440,360}})));
  parameter Modelica.Units.SI.Temperature T_cons_start=290.15
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false";
equation
  connect(masFloSouCoo.ports[1], slaCeiSou.port_a) annotation (Line(points={{602,224},{612,224},{612,222},{622,222}},
                                                                                                color={0,127,255}));
  connect(prePre.ports[1], slaCeiSou.port_b) annotation (Line(points={{674,224},{658,224},{658,222},{642,222}},
                                                                                          color={0,127,255}));
  connect(booToReaSou.y, masFloSouCoo.m_flow_in) annotation (Line(points={{562,232},{580,232}},
                                                                                              color={0,0,127}));
  connect(attFlo.heaPorFro, slaCeiSou.surf_a)
    annotation (Line(points={{722,234},{722,244},{636,244},{636,232}},
                                                                   color={191,0,0}));
  connect(slaCeiSou.surf_b, attFlo.heaPorBac)
    annotation (Line(points={{636,212},{636,204},{722,204},{722,214.2}},
                                                                   color={191,0,0}));
  connect(conCoo_sou.on, booToReaSou.u)
    annotation (Line(points={{502,242},{530,242},{530,232},{538,232}},
                                                                   color={255,0,255}));
  connect(conCoo_sou.TRooSet, TSetRooCoo.y) annotation (Line(points={{478,250},{422,250}},
                                                                                         color={0,0,127}));
  connect(conCoo_sou.TSupSet, masFloSouCoo.T_in)
    annotation (Line(points={{502,250},{570,250},{570,228},{580,228}},
                                                                   color={0,0,127}));
  connect(masFloSouCoo1.ports[1], slaCeiNor.port_a)
    annotation (Line(points={{602,104},{622,104}}, color={0,127,255}));
  connect(prePre1.ports[1], slaCeiNor.port_b) annotation (Line(points={{674,104},{642,104}}, color={0,127,255}));
  connect(booToReaNor.y, masFloSouCoo1.m_flow_in) annotation (Line(points={{562,112},{580,112}}, color={0,0,127}));
  connect(attFloNor.heaPorFro, slaCeiNor.surf_a)
    annotation (Line(points={{722,114},{722,124},{636,124},{636,114}}, color={191,0,0}));
  connect(conCoo_nor.on, booToReaNor.u)
    annotation (Line(points={{502,122},{530,122},{530,112},{538,112}}, color={255,0,255}));
  connect(conCoo_nor.TSupSet, masFloSouCoo1.T_in)
    annotation (Line(points={{502,130},{570,130},{570,108},{580,108}}, color={0,0,127}));
  connect(slaCeiNor.surf_b, attFloNor.heaPorBac)
    annotation (Line(points={{636,94},{636,84},{722,84},{722,94.2}},         color={191,0,0}));
  connect(masFloSouCoo2.ports[1], slaCeiEas.port_a)
    annotation (Line(points={{602,164},{622,164}}, color={0,127,255}));
  connect(prePre2.ports[1], slaCeiEas.port_b) annotation (Line(points={{674,164},{642,164}}, color={0,127,255}));
  connect(booToReaEas.y, masFloSouCoo2.m_flow_in) annotation (Line(points={{562,172},{580,172}}, color={0,0,127}));
  connect(attFloEas.heaPorFro, slaCeiEas.surf_a)
    annotation (Line(points={{722,174},{722,184},{636,184},{636,174}}, color={191,0,0}));
  connect(conCoo_eas.on, booToReaEas.u)
    annotation (Line(points={{502,182},{530,182},{530,172},{538,172}}, color={255,0,255}));
  connect(conCoo_eas.TSupSet, masFloSouCoo2.T_in)
    annotation (Line(points={{502,190},{570,190},{570,168},{580,168}}, color={0,0,127}));
  connect(slaCeiEas.surf_b, attFloEas.heaPorBac)
    annotation (Line(points={{636,154},{636,144},{722,144},{722,154.2}}, color={191,0,0}));
  connect(masFloSouCoo3.ports[1], slaCeiWes.port_a)
    annotation (Line(points={{602,44},{622,44}},     color={0,127,255}));
  connect(prePre3.ports[1], slaCeiWes.port_b) annotation (Line(points={{674,44},{642,44}},     color={0,127,255}));
  connect(booToReaWes.y, masFloSouCoo3.m_flow_in)
    annotation (Line(points={{562,52},{580,52}},     color={0,0,127}));
  connect(attFloWes.heaPorFro, slaCeiWes.surf_a)
    annotation (Line(points={{722,54},{722,64},{636,64},{636,54}},         color={191,0,0}));
  connect(conCoo_wes.on, booToReaWes.u)
    annotation (Line(points={{502,62},{530,62},{530,52},{538,52}},         color={255,0,255}));
  connect(conCoo_wes.TSupSet, masFloSouCoo3.T_in)
    annotation (Line(points={{502,70},{570,70},{570,48},{580,48}},         color={0,0,127}));
  connect(slaCeiWes.surf_b, attFloWes.heaPorBac)
    annotation (Line(points={{636,34},{636,24},{722,24},{722,34.2}},         color={191,0,0}));
  connect(masFloSouCoo4.ports[1], slaCeiCor.port_a)
    annotation (Line(points={{602,-16},{622,-16}},   color={0,127,255}));
  connect(prePre4.ports[1], slaCeiCor.port_b) annotation (Line(points={{674,-16},{642,-16}},   color={0,127,255}));
  connect(booToReaCor.y, masFloSouCoo4.m_flow_in)
    annotation (Line(points={{562,-8},{580,-8}},     color={0,0,127}));
  connect(conCoo_cor.on, booToReaCor.u)
    annotation (Line(points={{502,2},{530,2},{530,-8},{538,-8}},           color={255,0,255}));
  connect(conCoo_cor.TSupSet, masFloSouCoo4.T_in)
    annotation (Line(points={{502,10},{570,10},{570,-12},{580,-12}},       color={0,0,127}));
  connect(TSetRooCoo.y, conCoo_eas.TRooSet)
    annotation (Line(points={{422,250},{472,250},{472,190},{478,190}},
                                                                     color={0,0,127}));
  connect(TSetRooCoo.y, conCoo_nor.TRooSet)
    annotation (Line(points={{422,250},{472,250},{472,130},{478,130}},
                                                                     color={0,0,127}));
  connect(TSetRooCoo.y, conCoo_wes.TRooSet)
    annotation (Line(points={{422,250},{472,250},{472,70},{478,70}},   color={0,0,127}));
  connect(TSetRooCoo.y, conCoo_cor.TRooSet)
    annotation (Line(points={{422,250},{472,250},{472,10},{478,10}},   color={0,0,127}));
  connect(demux_TRoo.y[1], conCoo_sou.TRoo)
    annotation (Line(points={{420,217.2},{470,217.2},{470,240},{478,240}},
                                                                       color={0,0,127}));
  connect(demux_TRoo.y[2], conCoo_eas.TRoo)
    annotation (Line(points={{420,218.6},{470,218.6},{470,180},{478,180}},
                                                                         color={0,0,127}));
  connect(demux_TRoo.y[3], conCoo_nor.TRoo)
    annotation (Line(points={{420,220},{470,220},{470,120},{478,120}},
                                                                     color={0,0,127}));
  connect(demux_TRoo.y[4], conCoo_wes.TRoo)
    annotation (Line(points={{420,221.4},{422,221.4},{422,216},{470,216},{470,60},{478,60}}, color={0,0,127}));
  connect(demux_TRoo.y[5], conCoo_cor.TRoo)
    annotation (Line(points={{420,222.8},{422,222.8},{422,216},{470,216},{470,0},{478,0}},   color={0,0,127}));
  connect(demux_PhiRoo.y[1], conCoo_sou.phiRoo)
    annotation (Line(points={{420,187.2},{460,187.2},{460,236},{478,236}},
                                                                         color={0,0,127}));
  connect(demux_PhiRoo.y[2], conCoo_eas.phiRoo)
    annotation (Line(points={{420,188.6},{460,188.6},{460,176},{478,176}}, color={0,0,127}));
  connect(demux_PhiRoo.y[3], conCoo_nor.phiRoo)
    annotation (Line(points={{420,190},{460,190},{460,116},{478,116}}, color={0,0,127}));
  connect(demux_PhiRoo.y[4], conCoo_wes.phiRoo)
    annotation (Line(points={{420,191.4},{460,191.4},{460,56},{478,56}},   color={0,0,127}));
  connect(demux_PhiRoo.y[5], conCoo_cor.phiRoo)
    annotation (Line(points={{420,192.8},{460,192.8},{460,-4},{478,-4}},   color={0,0,127}));
  connect(slaCeiCor.surf_a, attFloCor.heaPorFro)
    annotation (Line(points={{636,-6},{636,4},{722,4},{722,-6}},           color={191,0,0}));
  connect(slaCeiCor.surf_b, attFloCor.heaPorBac)
    annotation (Line(points={{636,-26},{636,-36},{722,-36},{722,-25.8}},     color={191,0,0}));
  connect(multiplex5_1.y, demux_TRoo.u)
    annotation (Line(points={{361,290},{380,290},{380,220},{398,220}}, color={0,0,127}));
  connect(multiplex5_2.y, demux_PhiRoo.u)
    annotation (Line(points={{361,168},{380,168},{380,190},{398,190}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingCooling_TRoom.mos" "Simulate and plot"),
    experiment(
      StartTime=16761600,
      StopTime=17020800,
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
end RadiantHeatingCooling_TRoom_Baseline;
