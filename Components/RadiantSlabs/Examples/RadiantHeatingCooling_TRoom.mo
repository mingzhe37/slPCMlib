within slPCMlib.Components.RadiantSlabs.Examples;
model RadiantHeatingCooling_TRoom
  "Example model with one thermal zone with a radiant floor where the cooling is controlled based on the room air temperature"
  extends slPCMlib.Components.RadiantSlabs.Examples.Unconditioned;
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

  constant Modelica.Units.SI.Area AFlo=185.8 "Floor area";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=8000
    "Nominal heat flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
      4200/10 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-9500
    "Nominal heat flow rate for cooling";
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal
      /4200/5 "Design water mass flow rate for heating";
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCeiSou(nLay=4, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),Buildings.HeatTransfer.Data.Solids.Concrete(x=
        0.02)}) "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{320,60},{340,80}})));
  // Floor slab
  // Ceiling slab
  Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCeiSou(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiSou,
    iLayPip=3,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=flo.sou.AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{342,14},{362,34}})));
  Buildings.Fluid.Sources.Boundary_ph prePre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{414,14},{394,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{302,14},{322,34}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = 299.15, y(final unit="K", displayUnit="degC")) "Room temperture set point for cooling"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=mCoo_flow_nominal/9500*6700)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{260,22},{280,42}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFlo(surfaceName="Attic_floor_perimeter_south")
    "Floor of the attic above the living room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={442,24})));

  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{200,34},{220,54}})));
//initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  //assert(
    //abs(
      //AFlo-zon.AFlo) < 0.1,
    //"Floor area AFlo differs from EnergyPlus floor area.");

  Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCeiNor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiSou,
    iLayPip=3,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=flo.nor.AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{342,-106},{362,-86}})));
  Buildings.Fluid.Sources.Boundary_ph prePre1(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{414,-106},{394,-86}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo1(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{302,-106},{322,-86}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=mCoo_flow_nominal/9500*5700)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{260,-98},{280,-78}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloNor(surfaceName="Attic_floor_perimeter_north")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={442,-96})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo1(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{200,-86},{220,-66}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCeiEas(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiSou,
    iLayPip=3,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=flo.eas.AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{342,-46},{362,-26}})));
  Buildings.Fluid.Sources.Boundary_ph prePre2(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{414,-46},{394,-26}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo2(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{302,-46},{322,-26}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2(realTrue=mCoo_flow_nominal/9500*4700)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{260,-38},{280,-18}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloEas(surfaceName="Attic_floor_perimeter_east")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={442,-36})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo2(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{200,-26},{220,-6}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCeiWes(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiSou,
    iLayPip=3,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=flo.wes.AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{342,-166},{362,-146}})));
  Buildings.Fluid.Sources.Boundary_ph prePre3(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{414,-166},{394,-146}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo3(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{302,-166},{322,-146}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3(realTrue=mCoo_flow_nominal/9500*3700)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{260,-158},{280,-138}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloWes(surfaceName="Attic_floor_perimeter_west")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={442,-156})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo3(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{200,-146},{220,-126}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCeiRev(nLay=4, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),Buildings.HeatTransfer.Data.Solids.Concrete(x=
        0.02)}) "Reversed layer configuration for core zone, as a walkaround to use living ceiling directly"
    annotation (Placement(transformation(extent={{360,60},{380,80}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab slaCeiCor(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiSou,
    iLayPip=3,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    nCir=4,
    A=flo.cor.AFlo,
    m_flow_nominal=mCoo_flow_nominal/9500*3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{342,-226},{362,-206}})));
  Buildings.Fluid.Sources.Boundary_ph prePre4(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{414,-226},{394,-206}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo4(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{302,-226},{322,-206}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(realTrue=mCoo_flow_nominal/9500*3000)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{260,-218},{280,-198}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFloCor(surfaceName="Core_ZN_ceiling")
    "Floor of the attic above the living room" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={442,-216})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo4(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{200,-206},{220,-186}})));
  Modelica.Blocks.Routing.DeMultiplex demux_TRoo(n=5)
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Modelica.Blocks.Routing.DeMultiplex demux_PhiRoo(n=5)
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
protected
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=idfName,
    epwName=epwName,
    weaName=weaName,
    computeWetBulbTemperature=false)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
equation
  connect(masFloSouCoo.ports[1], slaCeiSou.port_a) annotation (Line(points={{322,24},{342,24}}, color={0,127,255}));
  connect(prePre.ports[1], slaCeiSou.port_b) annotation (Line(points={{394,24},{362,24}}, color={0,127,255}));
  connect(booToRea.y,masFloSouCoo.m_flow_in)
    annotation (Line(points={{282,32},{300,32}},                         color={0,0,127}));
  connect(attFlo.heaPorFro, slaCeiSou.surf_a)
    annotation (Line(points={{442,34},{442,44},{356,44},{356,34}}, color={191,0,0}));
  connect(slaCeiSou.surf_b, attFlo.heaPorBac)
    annotation (Line(points={{356,14},{356,4},{442,4},{442,14.2}}, color={191,0,0}));
  connect(conCoo.on, booToRea.u) annotation (Line(points={{222,42},{250,42},{250,32},{258,32}},
                              color={255,0,255}));
  connect(conCoo.TRooSet, TSetRooCoo.y)
    annotation (Line(points={{198,50},{142,50}},     color={0,0,127}));
  connect(conCoo.TSupSet, masFloSouCoo.T_in) annotation (Line(points={{222,50},{290,50},{290,28},{300,28}},
                                        color={0,0,127}));
  connect(masFloSouCoo1.ports[1], slaCeiNor.port_a)
    annotation (Line(points={{322,-96},{342,-96}}, color={0,127,255}));
  connect(prePre1.ports[1], slaCeiNor.port_b) annotation (Line(points={{394,-96},{362,-96}}, color={0,127,255}));
  connect(booToRea1.y, masFloSouCoo1.m_flow_in) annotation (Line(points={{282,-88},{300,-88}},  color={0,0,127}));
  connect(attFloNor.heaPorFro, slaCeiNor.surf_a)
    annotation (Line(points={{442,-86},{442,-76},{356,-76},{356,-86}}, color={191,0,0}));
  connect(conCoo1.on, booToRea1.u)
    annotation (Line(points={{222,-78},{250,-78},{250,-88},{258,-88}},     color={255,0,255}));
  connect(conCoo1.TSupSet, masFloSouCoo1.T_in)
    annotation (Line(points={{222,-70},{290,-70},{290,-92},{300,-92}},  color={0,0,127}));
  connect(slaCeiNor.surf_b, attFloNor.heaPorBac)
    annotation (Line(points={{356,-106},{356,-116},{442,-116},{442,-105.8}}, color={191,0,0}));
  connect(masFloSouCoo2.ports[1], slaCeiEas.port_a)
    annotation (Line(points={{322,-36},{342,-36}}, color={0,127,255}));
  connect(prePre2.ports[1], slaCeiEas.port_b) annotation (Line(points={{394,-36},{362,-36}}, color={0,127,255}));
  connect(booToRea2.y, masFloSouCoo2.m_flow_in) annotation (Line(points={{282,-28},{300,-28}}, color={0,0,127}));
  connect(attFloEas.heaPorFro, slaCeiEas.surf_a)
    annotation (Line(points={{442,-26},{442,-16},{356,-16},{356,-26}}, color={191,0,0}));
  connect(conCoo2.on, booToRea2.u)
    annotation (Line(points={{222,-18},{250,-18},{250,-28},{258,-28}}, color={255,0,255}));
  connect(conCoo2.TSupSet, masFloSouCoo2.T_in)
    annotation (Line(points={{222,-10},{290,-10},{290,-32},{300,-32}}, color={0,0,127}));
  connect(slaCeiEas.surf_b, attFloEas.heaPorBac)
    annotation (Line(points={{356,-46},{356,-56},{442,-56},{442,-45.8}}, color={191,0,0}));
  connect(masFloSouCoo3.ports[1], slaCeiWes.port_a)
    annotation (Line(points={{322,-156},{342,-156}}, color={0,127,255}));
  connect(prePre3.ports[1], slaCeiWes.port_b) annotation (Line(points={{394,-156},{362,-156}}, color={0,127,255}));
  connect(booToRea3.y, masFloSouCoo3.m_flow_in) annotation (Line(points={{282,-148},{300,-148}},
                                                                                             color={0,0,127}));
  connect(attFloWes.heaPorFro, slaCeiWes.surf_a)
    annotation (Line(points={{442,-146},{442,-136},{356,-136},{356,-146}}, color={191,0,0}));
  connect(conCoo3.on, booToRea3.u)
    annotation (Line(points={{222,-138},{250,-138},{250,-148},{258,-148}},
                                                                   color={255,0,255}));
  connect(conCoo3.TSupSet, masFloSouCoo3.T_in)
    annotation (Line(points={{222,-130},{290,-130},{290,-152},{300,-152}},
                                                                   color={0,0,127}));
  connect(slaCeiWes.surf_b, attFloWes.heaPorBac)
    annotation (Line(points={{356,-166},{356,-176},{442,-176},{442,-165.8}}, color={191,0,0}));
  connect(masFloSouCoo4.ports[1], slaCeiCor.port_a)
    annotation (Line(points={{322,-216},{342,-216}}, color={0,127,255}));
  connect(prePre4.ports[1], slaCeiCor.port_b) annotation (Line(points={{394,-216},{362,-216}}, color={0,127,255}));
  connect(booToRea4.y, masFloSouCoo4.m_flow_in) annotation (Line(points={{282,-208},{300,-208}},
                                                                                               color={0,0,127}));
  connect(conCoo4.on, booToRea4.u)
    annotation (Line(points={{222,-198},{250,-198},{250,-208},{258,-208}},
                                                                       color={255,0,255}));
  connect(conCoo4.TSupSet, masFloSouCoo4.T_in)
    annotation (Line(points={{222,-190},{290,-190},{290,-212},{300,-212}},
                                                                     color={0,0,127}));
  connect(slaCeiCor.surf_a, attFloCor.heaPorBac)
    annotation (Line(points={{356,-206},{356,-200},{442,-200},{442,-206.2}}, color={191,0,0}));
  connect(slaCeiCor.surf_b, attFloCor.heaPorFro)
    annotation (Line(points={{356,-226},{356,-232},{442,-232},{442,-226}}, color={191,0,0}));
  connect(TSetRooCoo.y, conCoo2.TRooSet)
    annotation (Line(points={{142,50},{192,50},{192,-10},{198,-10}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo1.TRooSet)
    annotation (Line(points={{142,50},{192,50},{192,-70},{198,-70}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo3.TRooSet)
    annotation (Line(points={{142,50},{192,50},{192,-130},{198,-130}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo4.TRooSet)
    annotation (Line(points={{142,50},{192,50},{192,-190},{198,-190}}, color={0,0,127}));
  connect(demux_TRoo.y[1], conCoo.TRoo)
    annotation (Line(points={{140,17.2},{190,17.2},{190,40},{198,40}}, color={0,0,127}));
  connect(demux_TRoo.y[2], conCoo2.TRoo)
    annotation (Line(points={{140,18.6},{190,18.6},{190,-20},{198,-20}}, color={0,0,127}));
  connect(demux_TRoo.y[3], conCoo1.TRoo)
    annotation (Line(points={{140,20},{190,20},{190,-80},{198,-80}}, color={0,0,127}));
  connect(demux_TRoo.y[4], conCoo3.TRoo)
    annotation (Line(points={{140,21.4},{142,21.4},{142,16},{190,16},{190,-140},{198,-140}}, color={0,0,127}));
  connect(demux_TRoo.y[5], conCoo4.TRoo)
    annotation (Line(points={{140,22.8},{142,22.8},{142,16},{190,16},{190,-200},{198,-200}}, color={0,0,127}));
  connect(flo.TRooAir, demux_TRoo.u)
    annotation (Line(points={{87.1739,13},{87.1739,12},{110,12},{110,20},{118,20}}, color={0,0,127}));
  connect(flo.TRooPhi, demux_PhiRoo.u)
    annotation (Line(points={{87.1739,8.38462},{110,8.38462},{110,-10},{118,-10}}, color={0,0,127}));
  connect(demux_PhiRoo.y[1], conCoo.phiRoo)
    annotation (Line(points={{140,-12.8},{180,-12.8},{180,36},{198,36}}, color={0,0,127}));
  connect(demux_PhiRoo.y[2], conCoo2.phiRoo)
    annotation (Line(points={{140,-11.4},{180,-11.4},{180,-24},{198,-24}}, color={0,0,127}));
  connect(demux_PhiRoo.y[3], conCoo1.phiRoo)
    annotation (Line(points={{140,-10},{180,-10},{180,-84},{198,-84}}, color={0,0,127}));
  connect(demux_PhiRoo.y[4], conCoo3.phiRoo)
    annotation (Line(points={{140,-8.6},{180,-8.6},{180,-144},{198,-144}}, color={0,0,127}));
  connect(demux_PhiRoo.y[5], conCoo4.phiRoo)
    annotation (Line(points={{140,-7.2},{180,-7.2},{180,-204},{198,-204}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingCooling_TRoom.mos" "Simulate and plot"),
    experiment(
      StartTime=16761600,
      StopTime=17366400,
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
        extent={{-100,-280},{480,80}})),
    Icon(
      coordinateSystem(
        extent={{-100,-280},{480,80}})));
end RadiantHeatingCooling_TRoom;
