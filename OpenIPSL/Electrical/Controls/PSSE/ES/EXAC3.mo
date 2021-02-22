within OpenIPSL.Electrical.Controls.PSSE.ES;
model EXAC3 "AC3 Excitation System [IEEE1981]"
  extends OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.BaseExciter;
  import OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.invFEX;
  import OpenIPSL.NonElectrical.Functions.SE;
  parameter OpenIPSL.Types.Time T_R=0.0 "Regulator input filter time constant";
  parameter OpenIPSL.Types.Time T_B=0.0 "Regulator denominator (lag) time constant";
  parameter OpenIPSL.Types.Time T_C=0.0 "Regulator numerator (lead) time constant";
  parameter OpenIPSL.Types.PerUnit K_A=78.04 "Regulator output gain";
  parameter OpenIPSL.Types.Time T_A=0.013 "Regulator output time constant";
  parameter OpenIPSL.Types.PerUnit V_AMAX=1 "Maximum regulator output";
  parameter OpenIPSL.Types.PerUnit V_AMIN=-0.95 "Minimum regulator output";
  parameter OpenIPSL.Types.Time T_E=3.71 "Exciter field time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_LV = 0.167 "Limiter control circuitry gain";
  parameter OpenIPSL.Types.PerUnit K_R = 6.99 " Regulator and alternator field power constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_F=0.143 "Rate feedback excitation system stabilizer gain when EFD is less than EFD_N";
  parameter OpenIPSL.Types.Time T_F=1 "Rate feedback time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_N=0.05 "Rate feedback excitation system stabilizer gain when EFD is greater than EFD_N";
  parameter OpenIPSL.Types.PerUnit EFD_N = 1.603 "Value of EFD at which feedback gain changes";
  parameter OpenIPSL.Types.PerUnit K_C=0.14 "Rectifier loading factor proportional to commutating reactance";
  parameter OpenIPSL.Types.PerUnit K_D=1.02 "Demagnetizing factor, function of exciter alternator reactances";
  parameter OpenIPSL.Types.PerUnit K_E=1 "Exciter field proportional constant";
  parameter OpenIPSL.Types.PerUnit V_LV=0.46 "Low voltage limit reference value";
  parameter OpenIPSL.Types.PerUnit E_1=4.64 "Exciter output voltage for saturation factor S_E(E_1)";
  parameter OpenIPSL.Types.PerUnit S_EE_1=0.186 "Exciter saturation factor at exciter output voltage E1";
  parameter OpenIPSL.Types.PerUnit E_2=6.19 "Exciter output voltage for saturation factor S_E(E_2)";
  parameter OpenIPSL.Types.PerUnit S_EE_2=1.391 "Exciter saturation factor at exciter output voltage E2";

  OpenIPSL.NonElectrical.Continuous.SimpleLagLim regulator(
    K=K_A,
    T=T_A,
    outMax=V_AMAX,
    outMin=V_AMIN,
    y_start=VA0)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  Modelica.Blocks.Continuous.Derivative rate_feedback(
    k=1,
    T=T_F,
    y_start=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start=0)
    annotation (Placement(transformation(extent={{0,-80},{-20,-60}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag trans_gain_reducer(
    K=1,
    T1=T_C,
    T2=T_B,
    y_start=VA0/K_A,
    x_start=VA0/K_A)
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Modelica.Blocks.Math.Add3 add_suppl_signals
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.RectifierCommutationVoltageDrop rectifierCommutationVoltageDrop(
      K_C=K_C)
    annotation (Placement(transformation(extent={{162,-10},{182,10}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.RotatingExciterWithDemagnetizationLimited
    rotatingExciterWithDemagnetizationLimited(
    T_E=T_E,
    K_E=K_E,
    E_1=E_1,
    E_2=E_2,
    S_EE_1=S_EE_1,
    S_EE_2=S_EE_2,
    K_D=K_D,
    Efd0=VE0)
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag transducer(
    K=1,
    T=T_R,
    y_start=ECOMP0)
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Modelica.Blocks.Math.Gain alternator_gain(k=K_R)
    annotation (Placement(transformation(extent={{120,-44},{100,-24}})));
  Modelica.Blocks.Math.Gain comparison_gain(k=K_LV) annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={92,56})));
  Modelica.Blocks.Math.Add error(k2=-1) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={128,56})));
  Modelica.Blocks.Sources.Constant low_voltage_ref(k=V_LV) annotation (
      Placement(transformation(extent={{10,-10},{-10,10}}, origin={172,56})));
  Modelica.Blocks.Math.Add add_els        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-96,-138})));
  OpenIPSL.NonElectrical.Logical.HV_GATE hV_GATE
    annotation (Placement(transformation(extent={{20,-6},{42,6}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Sources.RealExpression noninear_feedback(y=V_N)
    annotation (Placement(transformation(extent={{44,-80},{24,-60}})));
protected
  Real V_N;
  parameter Real VA0(fixed=false);
  parameter Real VFE0(fixed=false);
  parameter Real Ifd0(fixed=false);
  parameter Real VE0(fixed=false);
  parameter Real VN0(fixed=false);
initial equation
  Ifd0 = XADIFD;
  // Finding initial value of excitation voltage, VE0, via going through conditions of FEX function
  VE0 = invFEX(
    K_C=K_C,
    Efd0=Efd0,
    Ifd0=Ifd0);
  // Case IN>0 not checked because it will be resolved in the next iteration
  VFE0 = VE0*(SE(
    VE0,
    S_EE_1,
    S_EE_2,
    E_1,
    E_2) + K_E) + Ifd0*K_D;
  VN0 = if (Efd0>EFD_N) then K_F*Efd0 else K_N*Efd0;
  VA0 = VFE0/(K_R*Efd0);
  V_REF = VA0/K_A + ECOMP0;
equation
  V_N = if (EFD>EFD_N) then K_F*EFD else K_N*EFD;
  connect(rectifierCommutationVoltageDrop.XADIFD, XADIFD) annotation (Line(
        points={{172,-11},{172,-164},{80,-164},{80,-200}},    color={0,0,127}));
  connect(rotatingExciterWithDemagnetizationLimited.EFD,
    rectifierCommutationVoltageDrop.V_EX)
    annotation (Line(points={{151.25,0},{161,0}},            color={0,0,127}));
  connect(rectifierCommutationVoltageDrop.EFD, EFD)
    annotation (Line(points={{183,0},{210,0}},         color={0,0,127}));
  connect(DiffV.y, add_suppl_signals.u2)
    annotation (Line(points={{-99,0},{-84,0}}, color={0,0,127}));
  connect(ECOMP, transducer.u)
    annotation (Line(points={{-200,0},{-172,0}}, color={0,0,127}));
  connect(transducer.y, DiffV.u2) annotation (Line(points={{-149,0},{-132,0},{-132,
          -6},{-122,-6}}, color={0,0,127}));
  connect(comparison_gain.u, error.y)
    annotation (Line(points={{104,56},{117,56}}, color={0,0,127}));
  connect(VUEL, add_els.u1) annotation (Line(points={{-130,-200},{-130,-160},{-102,
          -160},{-102,-150}}, color={0,0,127}));
  connect(VOEL, add_els.u2) annotation (Line(points={{-70,-200},{-70,-160},{-90,
          -160},{-90,-150}}, color={0,0,127}));
  connect(add_els.y, add_suppl_signals.u3)
    annotation (Line(points={{-96,-127},{-96,-8},{-84,-8}}, color={0,0,127}));
  connect(VOTHSG, add_suppl_signals.u1) annotation (Line(points={{-200,90},{-96,
          90},{-96,8},{-84,8}}, color={0,0,127}));
  connect(low_voltage_ref.y, error.u1) annotation (Line(points={{161,56},{
          148,56},{148,62},{140,62}}, color={0,0,127}));
  connect(error.u2, EFD) annotation (Line(points={{140,50},{148,50},{148,26},
          {196,26},{196,0},{210,0}}, color={0,0,127}));
  connect(rotatingExciterWithDemagnetizationLimited.XADIFD, XADIFD) annotation (
     Line(points={{140,-11.25},{140,-164},{80,-164},{80,-200}}, color={0,0,127}));
  connect(add_suppl_signals.y, feedback.u1)
    annotation (Line(points={{-61,0},{-48,0}}, color={0,0,127}));
  connect(trans_gain_reducer.u, feedback.y)
    annotation (Line(points={{-20,0},{-31,0}}, color={0,0,127}));
  connect(trans_gain_reducer.y, hV_GATE.n2) annotation (Line(points={{3,0},{14,0},
          {14,-3},{18.625,-3}}, color={0,0,127}));
  connect(hV_GATE.p, regulator.u)
    annotation (Line(points={{40.625,0},{50,0}}, color={0,0,127}));
  connect(regulator.y, product1.u1)
    annotation (Line(points={{73,0},{80,0},{80,6},{92,6}}, color={0,0,127}));
  connect(rotatingExciterWithDemagnetizationLimited.I_C, product1.y)
    annotation (Line(points={{128.75,0},{115,0}}, color={0,0,127}));
  connect(comparison_gain.y, hV_GATE.n1) annotation (Line(points={{81,56},{14,56},
          {14,3},{18.625,3}}, color={0,0,127}));
  connect(alternator_gain.u, EFD) annotation (Line(points={{122,-34},{196,-34},{
          196,0},{210,0}}, color={0,0,127}));
  connect(alternator_gain.y, product1.u2) annotation (Line(points={{99,-34},{80,
          -34},{80,-6},{92,-6}}, color={0,0,127}));
  connect(rate_feedback.y, feedback.u2)
    annotation (Line(points={{-21,-70},{-40,-70},{-40,-8}}, color={0,0,127}));
  connect(noninear_feedback.y, rate_feedback.u)
    annotation (Line(points={{23,-70},{2,-70}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-200},{200,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={             Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="EXAC3")}),
    Documentation(info="<html>IEEE Type AC3 Excitation System Model.</html>",
  revisions="<html><table cellspacing=\"1\" cellpadding=\"1\" border=\"1\">
<tr>
<td><p>Reference</p></td>
<td>PSS&reg;E Manual</td>
</tr>
<tr>
<td><p>Last update</p></td>
<td><p>2021-02</p></td>
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
end EXAC3;