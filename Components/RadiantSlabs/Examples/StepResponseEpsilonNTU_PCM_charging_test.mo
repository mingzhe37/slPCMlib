within slPCMlib.Components.RadiantSlabs.Examples;
model StepResponseEpsilonNTU_PCM_charging_test "Model that tests the radiant slab with epsilon-NTU configuration"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water;
  Buildings.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=298.15,
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=86400,
    startTime=0,
    amplitude=-designPar.mCoo_flow_nominal_Sou,
    offset=designPar.mCoo_flow_nominal_Sou)
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.167
    "Nominal mass flow rate";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAirAbo(T=293.15)
    "Air temperature above the slab"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TRadAbo(T=293.15)
    "Radiant temperature above the slab"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAirBel(T=293.15)
    "Air temperature below the slab"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TRadBel(T=293.15)
    "Radiant temperature below the slab"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.HeatTransfer.Convection.Interior conAbo(
    A=A,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    til=Buildings.Types.Tilt.Floor) "Convective heat transfer above the slab"
    annotation (Placement(transformation(extent={{0,60},{-20,80}})));
  parameter Modelica.Units.SI.Area A=10 "Heat transfer area";
  Buildings.HeatTransfer.Convection.Interior conBel(
    A=A,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    til=Buildings.Types.Tilt.Ceiling) "Convective heat transfer below the slab"
    annotation (Placement(transformation(extent={{0,-60},{-20,-40}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation hRadAbo(Gr=A/(1/0.7 + 1
        /0.7 - 1)) "Radiative heat transfer above the slab"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation hRadBel(Gr=A/(1/0.7 + 1
        /0.7 - 1)) "Radiative heat transfer below the slab"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) "Outlet temperature of the slab"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
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
    T_c_start=T_c_start)
                 "Slab for ceiling with embedded pipes"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  BaseClasses.DesignPar designPar(
    QCoo_flow_nominal_Sou=-5000,
    QCoo_flow_nominal_Eas=-4000,
    QCoo_flow_nominal_Nor=-5000,
    QCoo_flow_nominal_Wes=-4500,
    QCoo_flow_nominal_Cor=-5000,
    Radiant_loop_spacing=0.15,
    PCM_thickness=0.05)          annotation (Placement(transformation(extent={{60,40},{80,60}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic PERClayCei(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Concrete(x=0.08),Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=
        0.10),Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.02)})
    "Material layers from surface a to b (8cm concrete, 10 cm insulation, 18+2 cm concrete)"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  parameter Modelica.Units.SI.Temperature T_c_start=T_cons_start
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false";
equation
  connect(pulse.y, sou.m_flow_in)       annotation (Line(
      points={{-59,-12},{-32,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirAbo.port, conAbo.fluid) annotation (Line(
      points={{-40,70},{-20,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadAbo.port, hRadAbo.port_a) annotation (Line(
      points={{-40,30},{-20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirBel.port, conBel.fluid) annotation (Line(
      points={{-40,-50},{-20,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadBel.port, hRadBel.port_a) annotation (Line(
      points={{-40,-90},{-20,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{60,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(TOut.port_a, slaCeiSou.port_b) annotation (Line(points={{40,-20},{30,-20}}, color={0,127,255}));
  connect(sou.ports[1], slaCeiSou.port_a) annotation (Line(points={{-10,-20},{10,-20}}, color={0,127,255}));
  connect(slaCeiSou.surf_a, hRadAbo.port_b) annotation (Line(points={{24,-10},{24,30},{0,30}}, color={191,0,0}));
  connect(slaCeiSou.surf_a, conAbo.solid) annotation (Line(points={{24,-10},{24,70},{0,70}}, color={191,0,0}));
  connect(slaCeiSou.surf_b, conBel.solid) annotation (Line(points={{24,-30},{24,-50},{0,-50}}, color={191,0,0}));
  connect(slaCeiSou.surf_b, hRadBel.port_b) annotation (Line(points={{24,-30},{24,-90},{0,-90}}, color={191,0,0}));
 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/StepResponseEpsilonNTU.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference</a>
except that the number of segments in the slab is set to <i>1</i>
and the heat transfer between the fluid and the slab is computed using
an epsilon-NTU model.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 7, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6));
end StepResponseEpsilonNTU_PCM_charging_test;
