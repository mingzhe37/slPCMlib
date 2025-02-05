within slPCMlib.Components.RadiantSlabs.Examples;
model RadiantHeatingCooling_TRoom_SF
  "Example model with one thermal zone with a radiant floor where the cooling is controlled based on the room air temperature"
  extends slPCMlib.Components.RadiantSlabs.Examples.Unconditioned_SF(zon(zoneName="living_unit1"), weaDat(relHumSou=
         Buildings.BoundaryConditions.Types.DataSource.Parameter, relHum=0.4));
  package MediumW=Buildings.Media.Water
    "Water medium";
  constant Modelica.Units.SI.Area AFlo=220.84 "Floor area";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=8000
    "Nominal heat flow rate for heating";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal=QHea_flow_nominal/
      4200/10 "Design water mass flow rate for heating";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-3000
    "Nominal heat flow rate for cooling";
  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal=-QCoo_flow_nominal
      /4200/5 "Design water mass flow rate for heating";
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCei(nLay=4, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.02),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.18),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  // Floor slab
  // Ceiling slab
  ParallelCircuitsSlab_PCM_fixed_Rx                                slaCei(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    layers=layCeiPCM,
    iLayPip=1,
    pipe=Buildings.Fluid.Data.Pipes.PEX_DN_15(),
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
    disPip=0.2,
    T_a_start=T_cons_start,
    T_b_start=T_cons_start,
    nCir=4,
    A=AFlo,
    m_flow_nominal=mCoo_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    PCM_thickness=0.1,
    T_c_start=T_cons_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{2,80},{22,100}})));
  Buildings.Fluid.Sources.Boundary_ph prePre(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 300000) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{74,80},{54,100}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSouCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source for cooling water at prescribed temperature"
    annotation (Placement(transformation(extent={{-38,80},{-18,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = 299.15, y(final unit="K", displayUnit="degC")) "Room temperture set point for cooling"
    annotation (Placement(transformation(extent={{-180,106},{-160,126}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=mCoo_flow_nominal)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{-80,88},{-60,108}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OpaqueConstruction attFlo(surfaceName="ceiling_unit1")
    "Floor of the attic above the living room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={102,90})));

  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo(TSupSet_min=289.15)
    "Controller for radiant cooling" annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layCeiPCM(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.02),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  parameter Modelica.Units.SI.Temperature T_cons_start=290.15
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false";
initial equation
  // The floor area can be obtained from EnergyPlus, but it is a structural parameter used to
  // size the system and therefore we hard-code it here.
  assert(
    abs(
      AFlo-zon.AFlo) < 0.1,
    "Floor area AFlo differs from EnergyPlus floor area.");

equation
  connect(masFloSouCoo.ports[1],slaCei.port_a)
    annotation (Line(points={{-18,90},{2,90}},  color={0,127,255}));
  connect(prePre.ports[1],slaCei.port_b)
    annotation (Line(points={{54,90},{22,90}},  color={0,127,255}));
  connect(booToRea.y,masFloSouCoo.m_flow_in)
    annotation (Line(points={{-58,98},{-40,98}},                         color={0,0,127}));
  connect(attFlo.heaPorFro,slaCei.surf_a)
    annotation (Line(points={{102,100},{102,110},{16,110},{16,100}},color={191,0,0}));
  connect(slaCei.surf_b,attFlo.heaPorBac)
    annotation (Line(points={{16,80},{16,70},{102,70},{102,80.2}},    color={191,0,0}));
  connect(conCoo.on, booToRea.u) annotation (Line(points={{-118,108},{-90,108},
          {-90,98},{-82,98}}, color={255,0,255}));
  connect(conCoo.TRooSet, TSetRooCoo.y)
    annotation (Line(points={{-142,116},{-158,116}}, color={0,0,127}));
  connect(zon.TAir, conCoo.TRoo) annotation (Line(points={{41,18},{48,18},{48,40},
          {-150,40},{-150,106},{-142,106}},     color={0,0,127}));
  connect(conCoo.phiRoo, zon.phi) annotation (Line(points={{-142,102},{-146,102},
          {-146,44},{52,44},{52,10},{41,10}}, color={0,0,127}));
  connect(conCoo.TSupSet, masFloSouCoo.T_in) annotation (Line(points={{-118,116},
          {-50,116},{-50,94},{-40,94}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/RadiantHeatingCooling_TRoom.mos" "Simulate and plot"),
    experiment(
      StartTime=17366400,
      StopTime=17625600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
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
        extent={{-220,-260},{160,200}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end RadiantHeatingCooling_TRoom_SF;
