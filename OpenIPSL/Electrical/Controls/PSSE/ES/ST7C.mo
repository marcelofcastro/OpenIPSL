within OpenIPSL.Electrical.Controls.PSSE.ES;
model ST7C "ST7C Excitation System [IEEE2016]"
  parameter OpenIPSL.Types.Time T_R=0.01 "Regulator input filter time constant";
  parameter OpenIPSL.Types.Time T_G=1.0 "Lead time constant of voltage input";
  parameter OpenIPSL.Types.Time T_F=1.0 "Lag time constant of voltage input";
  parameter OpenIPSL.Types.PerUnit Vmax=1.5 "Voltage referece maximum limit";
  parameter OpenIPSL.Types.PerUnit Vmin=0.5 "Voltage referece minimum limit";
  parameter OpenIPSL.Types.PerUnit K_PA=40.0 "Voltage regulator gain (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit V_RMAX=5.0 "Voltage regulator output maximum limit";
  parameter OpenIPSL.Types.PerUnit V_RMIN=-5.0 "Voltage regulator output minimum limit";
  parameter OpenIPSL.Types.PerUnit K_H = 1.0 "Feedback gain for high voltage gate";
  parameter OpenIPSL.Types.PerUnit K_L = 1.0 "Feedback gain for low voltage gate";
  parameter OpenIPSL.Types.Time T_C=1.0 "Lead time constant of voltage regulator";
  parameter OpenIPSL.Types.Time T_B=1.0 "Lag time constant of voltage regulator";
  parameter OpenIPSL.Types.PerUnit K_IA=1.0 "Gain of the first order feedback block (it must be greater than 0)";
  parameter OpenIPSL.Types.Time T_IA=3.0 "Time constant of the first order feedback block (it must be greater than 0)";
  parameter OpenIPSL.Types.Time T_A=0.01 "Thyristor bridge firing control equivalent time constant (it must be greater than 0)";
  Modelica.Blocks.Math.Add Verr1(k1=-1)
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-104,0})));
  OpenIPSL.NonElectrical.Logical.LV_GATE lV_Gate
    annotation (Placement(transformation(extent={{-108,-58},{-86,-46}})));
  OpenIPSL.NonElectrical.Logical.HV_GATE hV_Gate
    annotation (Placement(transformation(extent={{-138,-58},{-114,-46}})));
  Modelica.Blocks.Math.Gain ErrorGain(k=K_PA) annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-44,0})));
  OpenIPSL.NonElectrical.Continuous.SimpleLagLimVar simpleLagLimVar(
    K=1,
    T=T_A,
    y_start=Efd0)
    annotation (Placement(transformation(extent={{168,-10},{188,10}})));
  Modelica.Blocks.Math.Gain high(k=K_H)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={66,-100})));
  Modelica.Blocks.Math.Gain low(k=K_L)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={66,-66})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag transducer(
    K=1,
    T=T_R,
    y_start=ECOMP0)
    annotation (Placement(transformation(extent={{-174,-10},{-154,10}})));
  Modelica.Blocks.Interfaces.RealInput VOTHSG annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-200,90}), iconTransformation(extent={{-10,-10},{10,10}},
          origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput ECOMP annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-200,0}), iconTransformation(extent={{-10,-10},{10,10}}, origin={-110,0})));
  Modelica.Blocks.Interfaces.RealInput EFD0 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-200,-130}), iconTransformation(extent={{-10,-10},{10,10}},
          origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealInput VUEL annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-120,-200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-110})));
  Modelica.Blocks.Interfaces.RealInput VOEL annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-110})));
  Modelica.Blocks.Interfaces.RealInput XADIFD annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={120,-200}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-110})));
  Modelica.Blocks.Interfaces.RealOutput EFD "Excitation Voltage [pu]"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Constant VoltageReference(k=V_REF)
    annotation (Placement(transformation(extent={{-196,-48},{-176,-28}})));
  Modelica.Blocks.Math.Add3 add3_1
    annotation (Placement(transformation(extent={{-166,-56},{-146,-36}})));
  Modelica.Blocks.Interfaces.RealInput VUEL2
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-200}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-110})));
  Modelica.Blocks.Interfaces.RealInput VOEL2
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-200}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealInput VUEL3
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-200}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-110})));
  Modelica.Blocks.Interfaces.RealInput VOEL3
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,-200}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-110})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-84,-32})));
  Modelica.Blocks.Math.Add Vpss annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},      origin={-72,0})));
  OpenIPSL.NonElectrical.Continuous.LeadLag
                                   imLeadLag(
    K=1,
    T1=T_C,
    T2=T_B,
    y_start=ECOMP0,
    x_start=ECOMP0)
    annotation (Placement(transformation(extent={{-146,-10},{-126,10}})));
  OpenIPSL.NonElectrical.Logical.HV_GATE hV_GATE
    annotation (Placement(transformation(extent={{-24,-6},{0,6}})));
  OpenIPSL.NonElectrical.Logical.LV_GATE lV_GATE
    annotation (Placement(transformation(extent={{8,-6},{32,6}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag
                                   imLeadLag1(
    K=1,
    T1=T_C,
    T2=T_B,
    y_start=VR0,
    x_start=(V_REF - ECOMP0)*K_PA)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Add Vadd(k2=-1)
                                annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, origin={82,0})));
  OpenIPSL.NonElectrical.Logical.HV_GATE hV_GATE1
    annotation (Placement(transformation(extent={{102,-6},{126,6}})));
  OpenIPSL.NonElectrical.Logical.LV_GATE lV_GATE1
    annotation (Placement(transformation(extent={{134,-6},{158,6}})));
  Modelica.Blocks.Math.Add VLow(k2=-1)
                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={2,-26},
        rotation=90)));
  Modelica.Blocks.Math.Add VHigh(k1=-1)
                                annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},      origin={-30,-26},
        rotation=90)));
  Modelica.Blocks.Sources.RealExpression maxLim(y=V_RMAX*transducer.y)
    annotation (Placement(transformation(extent={{160,14},{180,34}})));
  Modelica.Blocks.Sources.RealExpression minLim(y=V_RMIN*transducer.y)
    annotation (Placement(transformation(extent={{144,-34},{164,-14}})));
  Modelica.Blocks.Sources.RealExpression maxLim2(y=V_RMIN*transducer.y)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-24,-60})));
  Modelica.Blocks.Sources.RealExpression minLim2(y=V_RMAX*transducer.y)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-60})));
  Modelica.Blocks.Continuous.FirstOrder feedback(
    k=K_IA,
    T=T_IA,
    y_start=K_IA*Efd0)
    annotation (Placement(transformation(extent={{172,-76},{152,-56}})));
protected
  parameter Real Efd0(fixed=false);
  parameter Real V_REF(fixed=false);
  parameter Real ECOMP0(fixed=false);
  parameter Real VR0(fixed=false);
initial equation
  Efd0 = EFD0;
  ECOMP0 = ECOMP;
  V_REF = (1+K_IA)*Efd0/K_PA + ECOMP0;
  VR0 = (1+K_IA)*Efd0;
equation
  connect(simpleLagLimVar.y, EFD) annotation (Line(points={{189,0},{210,0}},         color={0,0,127}));
  connect(ECOMP, transducer.u)
    annotation (Line(points={{-200,0},{-176,0}}, color={0,0,127}));
  connect(VoltageReference.y, add3_1.u1)
    annotation (Line(points={{-175,-38},{-168,-38}}, color={0,0,127}));
  connect(VUEL, add3_1.u2) annotation (Line(points={{-120,-200},{-120,-166},{-174,
          -166},{-174,-46},{-168,-46}},           color={0,0,127}));
  connect(VOEL, add3_1.u3) annotation (Line(points={{-80,-200},{-80,-162},{-172,
          -162},{-172,-54},{-168,-54}},
                                  color={0,0,127}));
  connect(add3_1.y, hV_Gate.n1) annotation (Line(points={{-145,-46},{-144,-46},
          {-144,-49},{-139.5,-49}},      color={0,0,127}));
  connect(hV_Gate.n2, VUEL2) annotation (Line(points={{-139.5,-55},{-144,-55},{
          -144,-158},{-40,-158},{-40,-200}},color={0,0,127}));
  connect(hV_Gate.p, lV_Gate.n1) annotation (Line(points={{-115.5,-52},{-114,
          -52},{-114,-49},{-109.375,-49}},
                                      color={0,0,127}));
  connect(VOEL2, lV_Gate.n2) annotation (Line(points={{0,-200},{0,-154},{-114,
          -154},{-114,-55},{-109.375,-55}},
                                      color={0,0,127}));
  connect(lV_Gate.p, limiter1.u) annotation (Line(points={{-87.375,-52},{-84,
          -52},{-84,-44}},
                      color={0,0,127}));
  connect(transducer.y, imLeadLag.u)
    annotation (Line(points={{-153,0},{-148,0}}, color={0,0,127}));
  connect(Vpss.y, ErrorGain.u)
    annotation (Line(points={{-61,0},{-56,0}}, color={0,0,127}));
  connect(ErrorGain.y, hV_GATE.n1) annotation (Line(points={{-33,0},{-32,0},{-32,
          3},{-25.5,3}}, color={0,0,127}));
  connect(hV_GATE.p, lV_GATE.n1)
    annotation (Line(points={{-1.5,0},{2,0},{2,3},{6.5,3}}, color={0,0,127}));
  connect(lV_GATE.p, imLeadLag1.u)
    annotation (Line(points={{30.5,0},{38,0}}, color={0,0,127}));
  connect(Verr1.y, Vpss.u2) annotation (Line(points={{-93,0},{-90,0},{-90,-6},{-84,
          -6}}, color={0,0,127}));
  connect(VOTHSG, Vpss.u1) annotation (Line(points={{-200,90},{-90,90},{-90,6},{
          -84,6}}, color={0,0,127}));
  connect(imLeadLag.y,Verr1. u1) annotation (Line(points={{-125,0},{-122,0},{-122,
          6},{-116,6}}, color={0,0,127}));
  connect(limiter1.y,Verr1. u2) annotation (Line(points={{-84,-21},{-84,-14},{-122,
          -14},{-122,-6},{-116,-6}}, color={0,0,127}));
  connect(hV_GATE1.p, lV_GATE1.n1) annotation (Line(points={{124.5,0},{128,0},{128,
          3},{132.5,3}}, color={0,0,127}));
  connect(Vadd.y, hV_GATE1.n1) annotation (Line(points={{93,0},{96,0},{96,3},{100.5,
          3}}, color={0,0,127}));
  connect(lV_GATE1.p, simpleLagLimVar.u)
    annotation (Line(points={{156.5,0},{166,0}}, color={0,0,127}));
  connect(VUEL3, hV_GATE1.n2) annotation (Line(points={{40,-200},{40,-154},{100.5,
          -154},{100.5,-3}}, color={0,0,127}));
  connect(VOEL3, lV_GATE1.n2) annotation (Line(points={{80,-200},{80,-158},{132.5,
          -158},{132.5,-3}}, color={0,0,127}));
  connect(imLeadLag1.y, Vadd.u1)
    annotation (Line(points={{61,0},{64,0},{64,6},{70,6}}, color={0,0,127}));
  connect(VLow.y, lV_GATE.n2)
    annotation (Line(points={{2,-15},{2,-3},{6.5,-3}}, color={0,0,127}));
  connect(VHigh.y, hV_GATE.n2)
    annotation (Line(points={{-30,-15},{-30,-3},{-25.5,-3}}, color={0,0,127}));
  connect(high.y, VHigh.u1) annotation (Line(points={{55,-100},{-36,-100},{-36,-38}},
        color={0,0,127}));
  connect(low.y, VLow.u2)
    annotation (Line(points={{55,-66},{8,-66},{8,-38}}, color={0,0,127}));
  connect(maxLim.y, simpleLagLimVar.outMax)
    annotation (Line(points={{181,24},{186,24},{186,14}}, color={0,0,127}));
  connect(minLim.y, simpleLagLimVar.outMin)
    annotation (Line(points={{165,-24},{170,-24},{170,-14}}, color={0,0,127}));
  connect(VHigh.u2, maxLim2.y)
    annotation (Line(points={{-24,-38},{-24,-49}}, color={0,0,127}));
  connect(VLow.u1, minLim2.y)
    annotation (Line(points={{-4,-38},{-4,-49}}, color={0,0,127}));
  connect(low.u, feedback.y)
    annotation (Line(points={{78,-66},{151,-66}}, color={0,0,127}));
  connect(feedback.u, EFD) annotation (Line(points={{174,-66},{196,-66},{196,0},
          {210,0}}, color={0,0,127}));
  connect(feedback.y, Vadd.u2) annotation (Line(points={{151,-66},{114,-66},{114,
          -22},{64,-22},{64,-6},{70,-6}}, color={0,0,127}));
  connect(high.u, feedback.y) annotation (Line(points={{78,-100},{114,-100},{114,
          -66},{151,-66}}, color={0,0,127}));
  annotation (
    Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255}),
          Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="ST7C"),
          Text(
          extent={{-100,-80},{-80,-100}},
          lineColor={28,108,200},
          textString="VUEL1"),
                             Text(
          extent={{-70,-80},{-50,-100}},
          lineColor={28,108,200},
          textString="VOEL1"),
                             Text(
          extent={{-90,10},{-20,-10}},
          lineColor={28,108,200},
          textString="ECOMP"),Text(
          extent={{-90,50},{-20,28}},
          lineColor={28,108,200},
          textString="VOTHSG"),Text(
          extent={{-90,-30},{-40,-52}},
          lineColor={28,108,200},
          textString="EFD0"),Text(
          extent={{50,10},{90,-10}},
          lineColor={28,108,200},
          textString="EFD"), Text(
          extent={{80,-80},{100,-100}},
          lineColor={28,108,200},
          textString="XADIFD"),          Text(
          extent={{-40,-80},{-20,-100}},
          lineColor={28,108,200},
          textString="VUEL2"),           Text(
          extent={{-10,-80},{10,-100}},
          lineColor={28,108,200},
          textString="VOEL2"),           Text(
          extent={{20,-80},{40,-100}},
          lineColor={28,108,200},
          textString="VUEL3"),           Text(
          extent={{48,-80},{68,-100}},
          lineColor={28,108,200},
          textString="VOEL3")}),
    Diagram(coordinateSystem(extent={{-200,-200},{200,160}}),
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true,
        grid={2,2}), graphics={Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="ST7C")},
    Documentation(revisions="<html>
<table cellspacing=\"1\" cellpadding=\"1\" border=\"1\">
<tr>
<td><p>Reference</p></td>
<td>PSS&reg;E Manual</td>
</tr>
<tr>
<td><p>Last update</p></td>
<td>2020-01-22</td>
</tr>
<tr>
<td><p>Author</p></td>
<td><p><a href=\"https://github.com/marcelofcastro\">@marcelofcastro</a></p></td>
</tr>
<tr>
<td><p>Contact</p></td>
<td><p>see <a href=\"modelica://OpenIPSL.UsersGuide.Contact\">UsersGuide.Contact</a></p></td>
</tr>
</table>
</html>"));