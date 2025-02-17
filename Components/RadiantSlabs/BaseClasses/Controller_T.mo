within slPCMlib.Components.RadiantSlabs.BaseClasses;
model Controller_T
  parameter Real mRadWatSup(
      final unit="kg/s") "Output signal for true Boolean input";
  parameter Real TSupSet_max(
      final unit="K",
      displayUnit="degC")=297.15 "Maximum chilled supply water temperature";
  parameter Real TSupSet_min(
      final unit="K",
      displayUnit="degC")=288.15 "Minimum chilled supply water temperature";
  parameter Real TCharging(
      final unit="K",
    displayUnit="degC") = 285.15 "Chilled water PCM charging temperature - off peak";
  parameter Real mCharging(
      final unit="kg/s") = mRadWatSup "Chilled water PCM charging flow rate - off peak";

  parameter Real table[:,:]=[0,0; 7,1; 19,1; 24,0]
    "Table matrix with time as a first column (in seconds, unless timeScale is not 1) 
    and 0 for False or 1 for True in all other columns";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRooCoo(k(
      final unit="K",
      displayUnit="degC") = TSetZone,
                                    y(final unit="K", displayUnit="degC")) "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo(
    TSupSet_max=TSupSet_max,
    TSupSet_min=TSupSet_min,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=2,
    Ti=7200,
    Td=600) "Controller for radiant heating system"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiHeaPum "Switch for heat pump signal"
    annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_Charging(final k(final unit="kg/s") = mCharging)
                                                                                    "Output 0 to switch heater off"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiPum "Switch for circulation pumps"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And onHeaPum "On/off signal for heat pump"
    annotation (Placement(transformation(extent={{8,20},{28,40}})));
  Modelica.Blocks.Interfaces.RealInput temZon annotation (Placement(transformation(extent={{-140,40},
            {-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput phiZon annotation (Placement(transformation(extent={{-140,
            -100},{-100,-60}}), iconTransformation(extent={{-140,-100},{-100,
            -60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSou(realTrue=mRadWatSup)
    "Cooling water mass flow rate" annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Modelica.Blocks.Interfaces.RealOutput TSetCoo annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput mWatSup annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable loaSch(
    table=table,
    timeScale=3600,
    period=24*3600) "Load shifting schedule, true if normal operation mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSet_Charging(k(
      final unit="K",
      displayUnit="degC") = TCharging,
                                    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperture set point for charging"
    annotation (Placement(transformation(extent={{-100,-68},{-80,-48}})));
  parameter Real TSetZone(
    final unit="K",
    displayUnit="degC") = 297.15 "Constant output value";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput
                                            on
    "Outputs true if the system is demanded on" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-40},
            {140,0}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{74,-10},{94,10}})));
equation
  connect(mWat_Charging.y, swiPum.u3)
    annotation (Line(points={{-38,-90},{50,-90},{50,-58},{58,-58}}, color={0,0,127}));
  connect(conCoo.on, onHeaPum.u1)
    annotation (Line(points={{-18,82},{-2,82},{-2,30},{6,30}},                       color={255,0,255}));
  connect(swiPum.y, mWatSup) annotation (Line(points={{82,-50},{110,-50}},                   color={0,0,127}));
  connect(loaSch.y[1], swiPum.u2)
    annotation (Line(points={{-78,10},{-48,10},{-48,-36},{30,-36},{30,-50},{58,-50}},
                                                                    color={255,0,255}));
  connect(loaSch.y[1], swiHeaPum.u2)
    annotation (Line(points={{-78,10},{-48,10},{-48,-18},{-42,-18}},
                                                                  color={255,0,255}));
  connect(temZon, conCoo.TRoo) annotation (Line(points={{-120,60},{-70,60},{-70,
          80},{-42,80}},                                                                       color={0,0,127}));
  connect(loaSch.y[1], onHeaPum.u2) annotation (Line(points={{-78,10},{-2,10},{-2,22},{6,22}}, color={255,0,255}));
  connect(booToReaSou.y, swiPum.u1)
    annotation (Line(points={{38,-10},{32,-10},{32,-42},{58,-42}}, color={0,0,127}));
  connect(onHeaPum.y, booToReaSou.u)
    annotation (Line(points={{30,30},{68,30},{68,-10},{62,-10}}, color={255,0,255}));
  connect(TSet_Charging.y, swiHeaPum.u3)
    annotation (Line(points={{-78,-58},{-46,-58},{-46,-26},{-42,-26}}, color={0,0,127}));
  connect(TSetRooCoo.y, conCoo.TRooSet) annotation (Line(points={{-78,90},{-42,90}}, color={0,0,127}));
  connect(conCoo.TSupSet, swiHeaPum.u1)
    annotation (Line(points={{-18,90},{-16,90},{-16,30},{-60,30},{-60,-10},{-42,-10}}, color={0,0,127}));
  connect(swiHeaPum.y, TSetCoo) annotation (Line(points={{-18,-18},{-8,-18},{-8,
          50},{110,50}}, color={0,0,127}));
  connect(phiZon, conCoo.phiRoo) annotation (Line(points={{-120,-80},{-66,-80},
          {-66,76},{-42,76}}, color={0,0,127}));
  connect(swiPum.y, greThr.u) annotation (Line(points={{82,-50},{90,-50},{90,
          -20},{70,-20},{70,0},{72,0}}, color={0,0,127}));
  connect(greThr.y, on)
    annotation (Line(points={{96,0},{120,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{58,86},{94,36}},
          textColor={0,0,127},
          textString="TSupSet"),
        Text(
          extent={{76,-44},{96,-90}},
          textColor={0,0,127},
          textString="mPum"),
        Text(
          extent={{-92,92},{-48,44}},
          textColor={0,0,127},
          textString="TRoo"),
        Rectangle(
          extent={{-30,-16},{48,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{56,-82},{56,-26},{-24,-26},{-24,-20},{56,-20}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-30,-16},{48,48}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-100,60},{-64,60},{-64,26},{-30,26}}, color={28,108,200}),
        Line(points={{100,50},{74,50},{74,-36},{58,-36}}, color={28,108,200}),
        Ellipse(
          extent={{46,-50},{68,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,-50},{46,-60},{68,-60},{56,-50}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-60},{84,-60},{68,-60}}, color={28,108,200}),
        Ellipse(
          extent={{56,-32},{64,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-30,-8},{-66,-8},{-66,-80},{-100,-80}},
             color={28,108,200}),
        Text(
          extent={{-96,-44},{-76,-90}},
          textColor={0,0,127},
          textString="phi"),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"));
end Controller_T;
