within OpenIPSL.Electrical.Controls.PSSE.ES;
model REXSYS "General Purpose Rotating Excitation System"
import OpenIPSL.NonElectrical.Functions.SE;
  import OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.invFEX;
  extends OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.BaseExciter;
  parameter OpenIPSL.Types.Time T_R=0.028 "Regulator input filter time constant";
  parameter OpenIPSL.Types.PerUnit K_VP=350 "Voltage regulator proportional gain";
  parameter OpenIPSL.Types.PerUnit K_VI=0.0 "Voltage regulator integral gain";
  parameter OpenIPSL.Types.PerUnit V_IMAX=999 "Voltage regulator input limit";
  parameter OpenIPSL.Types.Time T_A=0.02 "Voltage regulator time constant";
  parameter OpenIPSL.Types.Time T_B1=0.0 "Regulator first denominator (lag) time constant";
  parameter OpenIPSL.Types.Time T_C1=0.0 "Regulator first numerator (lead) time constant";
  parameter OpenIPSL.Types.Time T_B2=0.0 "Regulator second denominator (lag) time constant";
  parameter OpenIPSL.Types.Time T_C2=0.0 "Regulator second numerator (lead) time constant";
  parameter OpenIPSL.Types.PerUnit V_RMAX=101.6 "Maximum controller output";
  parameter OpenIPSL.Types.PerUnit V_RMIN=-101.6 "Minimum controller output";
  parameter OpenIPSL.Types.PerUnit K_F=0.0487 "Rate feedback gain";
  parameter OpenIPSL.Types.Time T_F=2 "Rate feedback time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.Time T_F1=0.0 "Feedback lead-time const";
  parameter OpenIPSL.Types.Time T_F2=0.0 "Feedback lag-time const";
  parameter Integer F_BF=1 "Rate feedback signal flag"  annotation (Evaluate=true, choices(
       choice=0 "Regulator output - V_R",
       choice=1 "Field current - I_FE",
       choice=2 "Field voltage - EFD"));
  parameter OpenIPSL.Types.PerUnit K_IP=1 "Field current regulator proportional gain";
  parameter OpenIPSL.Types.PerUnit K_II=0.0 "Field current regulator integral gain";
  parameter OpenIPSL.Types.Time T_P=0.0 "Field current bridge time constant";
  parameter OpenIPSL.Types.PerUnit V_FMAX=999 "Maximum exciter field current";
  parameter OpenIPSL.Types.PerUnit V_FMIN=-999 "Minimum exciter field current";
  parameter OpenIPSL.Types.PerUnit K_H=0 "Field voltage controller feedback gain";
  parameter OpenIPSL.Types.PerUnit K_E=1 "Exciter field proportional constant";
  parameter OpenIPSL.Types.Time T_E=0.55 "Exciter field time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_C=0.0 "Rectifier loading factor proportional to commutating reactance";
  parameter OpenIPSL.Types.PerUnit K_D=0.0 "Demagnetizing factor, function of exciter alternator reactances";
  parameter OpenIPSL.Types.PerUnit E_1=3.06 "Exciter output voltage for saturation factor S_E(E_1)";
  parameter OpenIPSL.Types.PerUnit S_EE_1=0.1 "Exciter saturation factor at exciter output voltage E1";
  parameter OpenIPSL.Types.PerUnit E_2=4.08 "Exciter output voltage for saturation factor S_E(E_2)";
  parameter OpenIPSL.Types.PerUnit S_EE_2=0.3 "Exciter saturation factor at exciter output voltage E2";
  parameter OpenIPSL.Types.PerUnit F_1IMF=0 "Power supply limit factor";

  OpenIPSL.NonElectrical.Continuous.LeadLag trans_red_1(
    K=1,
    T1=T_C1,
    T2=T_B1,
    y_start=VFE0*K_H,
    x_start=VFE0*K_H)
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag transducer(
    K=1,
    y_start=ECOMP0,
    T=T_R)
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Modelica.Blocks.Nonlinear.Limiter current_limiter(uMax=F*V_FMAX, uMin=F*
        V_FMIN)
    annotation (Placement(transformation(extent={{106,-76},{126,-56}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLagLim regulator(
    K=1,
    T=T_A,
    y_start=VFE0*K_H,
    outMax=F*V_RMAX,
    outMin=F*V_RMIN)
    annotation (Placement(transformation(extent={{112,-10},{132,10}})));
  Modelica.Blocks.Continuous.Derivative rate_feedback(
    k=K_F,
    T=T_F,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0,
    x_start=VFEED0)
    annotation (Placement(transformation(extent={{28,74},{8,94}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.RotatingExciterWithDemagnetizationLimited
    rotatingExciterWithDemagnetization(
    T_E=T_E,
    K_E=K_E,
    E_1=E_1,
    E_2=E_2,
    S_EE_1=S_EE_1,
    S_EE_2=S_EE_2,
    K_D=K_D,
    Efd0=VE0) annotation (Placement(transformation(extent={{136,-76},{156,
            -56}})));
  Modelica.Blocks.Math.Add3 add_sup_signals(k3=-1)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.RectifierCommutationVoltageDrop rectifierCommutationVoltageDrop(
      K_C=K_C)
    annotation (Placement(transformation(extent={{162,-76},{182,-56}})));
  Modelica.Blocks.Math.Add add_els annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-96,-124})));
  Modelica.Blocks.Math.Gain current_feedback_gain(k=K_H)
    annotation (Placement(transformation(extent={{106,-118},{86,-98}})));
  Modelica.Blocks.Math.Feedback current_control_feedback
    annotation (Placement(transformation(extent={{-24,-76},{-4,-56}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag trans_red_2(
    K=1,
    T1=T_C2,
    T2=T_B2,
    y_start=VFE0*K_H,
    x_start=VFE0*K_H)
    annotation (Placement(transformation(extent={{84,-10},{104,10}})));
  Modelica.Blocks.Nonlinear.Limiter error_limiter(uMax=V_IMAX, uMin=-V_IMAX)
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag trans_red_3(
    K=1,
    T1=T_F1,
    T2=T_F2,
    y_start=0,
    x_start=0)
    annotation (Placement(transformation(extent={{-12,74},{-32,94}})));
  Modelica.Blocks.Math.Feedback avr_feedback
    annotation (Placement(transformation(extent={{-64,10},{-44,-10}})));
  Modelica.Blocks.Sources.RealExpression feedback_signal(y=V_FEED)
    annotation (Placement(transformation(extent={{62,74},{42,94}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag bridge(
    K=1,
    y_start=VFE0,
    T=T_P)
    annotation (Placement(transformation(extent={{76,-76},{96,-56}})));
  Modelica.Blocks.Continuous.Integrator current_i_control(
    k=K_II,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=VFE0)
    annotation (Placement(transformation(extent={{10,-92},{30,-72}})));
  Modelica.Blocks.Math.Add add_pi_current
    annotation (Placement(transformation(extent={{42,-76},{62,-56}})));
  Modelica.Blocks.Math.Add add_pi_volt
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Math.Gain current_p_control(k=K_IP)
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Modelica.Blocks.Continuous.Integrator volt_i_control(
    k=K_VI,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0)
    annotation (Placement(transformation(extent={{-6,-26},{14,-6}})));
  Modelica.Blocks.Math.Gain volt_p_control(k=K_VP)
    annotation (Placement(transformation(extent={{-6,6},{14,26}})));
protected
  Real V_FEED;
  Real V_R = regulator.y;
  Real I_FE = rotatingExciterWithDemagnetization.V_FE;
  Real E_FD = EFD;
  parameter Real F(fixed=false);
  parameter Real VFEED0(fixed=false);
  parameter Real VR0(fixed=false);
  parameter Real Efd0(fixed=false);
  parameter Real Ifd0(fixed=false);
  parameter Real VE0(fixed=false);
  parameter Real VFE0(fixed=false);
initial equation
  F=(1+F_1IMF*(ECOMP0-1))*(K_E+K_D+SE(VE0,S_EE_1,S_EE_2,E_1,E_2));
  Ifd0 = XADIFD;
  VFEED0 = if (F_BF == 0) then VR0 elseif (F_BF == 1) then VFE0 else Efd0;
  VE0 = invFEX(
    K_C=K_C,
    Efd0=Efd0,
    Ifd0=Ifd0);
  VFE0 = VE0*(SE(
    VE0,
    S_EE_1,
    S_EE_2,
    E_1,
    E_2) + K_E) + Ifd0*K_D;
  VR0 = VFE0;
  V_REF = ECOMP0;
equation
  V_FEED = if (F_BF == 0) then V_R elseif (F_BF == 1) then I_FE else E_FD;
  connect(current_limiter.y, rotatingExciterWithDemagnetization.I_C)
    annotation (Line(points={{127,-66},{134.75,-66}}, color={0,0,127}));
  connect(ECOMP, transducer.u)
    annotation (Line(points={{-200,0},{-172,0}}, color={0,0,127}));
  connect(transducer.y, DiffV.u2) annotation (Line(points={{-149,0},{-132,0},
          {-132,-6},{-122,-6}}, color={0,0,127}));
  connect(DiffV.y, add_sup_signals.u2)
    annotation (Line(points={{-99,0},{-90,0}}, color={0,0,127}));
  connect(VOTHSG, add_sup_signals.u1) annotation (Line(points={{-200,90},{-96,90},
          {-96,8},{-90,8}}, color={0,0,127}));
  connect(rotatingExciterWithDemagnetization.EFD,
    rectifierCommutationVoltageDrop.V_EX)
    annotation (Line(points={{157.25,-66},{161,-66}},
                                                    color={0,0,127}));
  connect(rectifierCommutationVoltageDrop.EFD, EFD) annotation (Line(points={{183,-66},
          {196,-66},{196,0},{210,0}},        color={0,0,127}));
  connect(XADIFD, rotatingExciterWithDemagnetization.XADIFD) annotation (Line(points={{80,-200},
          {80,-126},{146,-126},{146,-77.25}},                                                                                      color={0,0,127}));
  connect(XADIFD, rectifierCommutationVoltageDrop.XADIFD) annotation (Line(points={{80,-200},
          {80,-126},{172,-126},{172,-77}},                                                                                   color={0,0,127}));
  connect(VUEL, add_els.u1) annotation (Line(points={{-130,-200},{-130,-168},{-102,
          -168},{-102,-136}}, color={0,0,127}));
  connect(VOEL, add_els.u2) annotation (Line(points={{-70,-200},{-70,-168},{-90,
          -168},{-90,-136}}, color={0,0,127}));
  connect(add_els.y, add_sup_signals.u3)
    annotation (Line(points={{-96,-113},{-96,-8},{-90,-8}}, color={0,0,127}));
  connect(rotatingExciterWithDemagnetization.V_FE, current_feedback_gain.u)
    annotation (Line(points={{134.75,-72.25},{128,-72.25},{128,-108},{108,
          -108}},
        color={0,0,127}));
  connect(current_feedback_gain.y, current_control_feedback.u2)
    annotation (Line(points={{85,-108},{-14,-108},{-14,-74}},
                                                          color={0,0,127}));
  connect(trans_red_3.u, rate_feedback.y)
    annotation (Line(points={{-10,84},{7,84}}, color={0,0,127}));
  connect(add_sup_signals.y, avr_feedback.u1)
    annotation (Line(points={{-67,0},{-62,0}}, color={0,0,127}));
  connect(avr_feedback.y, error_limiter.u)
    annotation (Line(points={{-45,0},{-40,0}}, color={0,0,127}));
  connect(trans_red_1.y, trans_red_2.u)
    annotation (Line(points={{77,0},{82,0}}, color={0,0,127}));
  connect(trans_red_2.y, regulator.u)
    annotation (Line(points={{105,0},{110,0}},
                                             color={0,0,127}));
  connect(trans_red_3.y, avr_feedback.u2)
    annotation (Line(points={{-33,84},{-54,84},{-54,8}}, color={0,0,127}));
  connect(rate_feedback.u, feedback_signal.y)
    annotation (Line(points={{30,84},{41,84}}, color={0,0,127}));
  connect(current_limiter.u, bridge.y)
    annotation (Line(points={{104,-66},{97,-66}}, color={0,0,127}));
  connect(bridge.u, add_pi_current.y)
    annotation (Line(points={{74,-66},{63,-66}}, color={0,0,127}));
  connect(error_limiter.y, volt_p_control.u) annotation (Line(points={{-17,
          0},{-14,0},{-14,16},{-8,16}}, color={0,0,127}));
  connect(volt_i_control.u, volt_p_control.u) annotation (Line(points={{-8,
          -16},{-14,-16},{-14,16},{-8,16}}, color={0,0,127}));
  connect(volt_p_control.y, add_pi_volt.u1) annotation (Line(points={{15,16},
          {18,16},{18,6},{24,6}}, color={0,0,127}));
  connect(volt_i_control.y, add_pi_volt.u2) annotation (Line(points={{15,
          -16},{18,-16},{18,-6},{24,-6}}, color={0,0,127}));
  connect(trans_red_1.u, add_pi_volt.y)
    annotation (Line(points={{54,0},{47,0}}, color={0,0,127}));
  connect(current_control_feedback.y, current_p_control.u) annotation (Line(
        points={{-5,-66},{2,-66},{2,-50},{8,-50}}, color={0,0,127}));
  connect(current_i_control.u, current_p_control.u) annotation (Line(points=
         {{8,-82},{2,-82},{2,-50},{8,-50}}, color={0,0,127}));
  connect(current_p_control.y, add_pi_current.u1) annotation (Line(points={
          {31,-50},{34,-50},{34,-60},{40,-60}}, color={0,0,127}));
  connect(add_pi_current.u2, current_i_control.y) annotation (Line(points={
          {40,-72},{34,-72},{34,-82},{31,-82}}, color={0,0,127}));
  connect(regulator.y, current_control_feedback.u1) annotation (Line(points=
         {{133,0},{138,0},{138,-34},{-32,-34},{-32,-66},{-22,-66}}, color={
          0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-200},{200,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={             Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="REXSYS")}),
    Documentation(info="<html>General Purpose Rotating Excitation System Model.</html>",
  revisions="<html><table cellspacing=\"1\" cellpadding=\"1\" border=\"1\">
<tr>
<td><p>Reference</p></td>
<td><p>PSS&reg;E Manual</p></td>
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
end REXSYS;