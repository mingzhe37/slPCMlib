within slPCMlib.Components;
model modSwi
  Modelica.Blocks.Interfaces.IntegerInput u[4] annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput yHeaPum annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.IntegerOutput yVal annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=if u[1] == 1 then 1 elseif u[2] == 1 then 2 elseif
        u[3] == 1 then 3 else 0) annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if u[1] == 1 then 1 else 0)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Interfaces.IntegerOutput heaPumOnOff
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=if u[1] == 1 then -1 else 0)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=if u[1] == 1 then 1 elseif u[2] == 1 then 1 else 0)
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Interfaces.RealOutput yFan annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  connect(integerExpression.y, yVal) annotation (Line(points={{61,60},{110,60}}, color={255,127,0}));
  connect(realExpression.y, yHeaPum) annotation (Line(points={{61,-20},{110,-20}}, color={0,0,127}));
  connect(integerExpression1.y, heaPumOnOff) annotation (Line(points={{61,20},{110,20}}, color={255,127,0}));
  connect(realExpression1.y, yFan) annotation (Line(points={{61,-60},{110,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end modSwi;
