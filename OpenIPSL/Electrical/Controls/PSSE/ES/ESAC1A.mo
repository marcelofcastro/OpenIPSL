within OpenIPSL.Electrical.Controls.PSSE.ES;
model ESAC1A
  import OpenIPSL.NonElectrical.Functions.SE;
  import OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.invFEX;
  extends OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.BaseExciter;
  parameter SI.Time T_R=0 "Regulator input filter time constant";
  parameter SI.Time T_B=0 "Regulator denominator (lag) time constant";
  parameter SI.Time T_C=0 "Regulator numerator (lead) time constant";
  parameter SI.PerUnit K_A=400 "Regulator output gain";
  parameter SI.Time T_A=0.02 "Regulator output time constant";
  parameter SI.PerUnit V_AMAX=9 "Maximum regulator output";
  parameter SI.PerUnit V_AMIN=-5.43 "Minimum regulator output";
  parameter SI.Time T_E=0.8 "Exciter field time constant";
  parameter SI.PerUnit K_F=0.03 "Rate feedback excitation system gain";
  parameter SI.Time T_F=1 "Rate feedback time const";
  parameter SI.PerUnit K_C=0.2 "Rectifier loading factor proportional to commutating reactance";
  parameter SI.PerUnit K_D=0.48 "Demagnetizing factor, function of exciter alternator reactances";
  parameter SI.PerUnit K_E=1 "Exciter field proportional constant";
  parameter SI.PerUnit E_1=5.25 "Exciter output voltage for saturation factor S_E(E_1)";
  parameter SI.PerUnit E_2=7 "Exciter output voltage for saturation factor S_E(E_2)";
  parameter SI.PerUnit S_EE_1=0.03 "Exciter saturation factor at exciter output voltage E1";
  parameter SI.PerUnit S_EE_2=0.1 "Exciter saturation factor at exciter output voltage E2";
  parameter SI.PerUnit V_RMAX=6.03 "Maximum exciter field output";
  parameter SI.PerUnit V_RMIN=-5.43 "Minimum exciter field output";
  NonElectrical.Logical.HV_GATE hV_GATE
    annotation (Placement(transformation(extent={{20,46},{44,34}})));
  NonElectrical.Logical.LV_GATE lV_GATE
    annotation (Placement(transformation(extent={{58,46},{82,34}})));
  NonElectrical.Continuous.LeadLag imLeadLag(
    K=1,
    T1=T_C,
    T2=T_B,
    y_start=VR0/K_A,
    x_start=VR0/K_A)
    annotation (Placement(transformation(extent={{-52,30},{-32,50}})));
  NonElectrical.Continuous.SimpleLag imSimpleLag(
    K=1,
    y_start=ECOMP0,
    T=T_R) annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{94,30},{114,50}})));
  NonElectrical.Continuous.SimpleLagLim simpleLagLim(
    K=K_A,
    T=T_A,
    y_start=VR0,
    outMax=V_AMAX,
    outMin=V_AMIN)
    annotation (Placement(transformation(extent={{-16,30},{4,50}})));
  Modelica.Blocks.Continuous.Derivative derivative(
    k=K_F,
    T=T_F,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0,
    x_start=VFE0)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  BaseClasses.RotatingExciterWithDemagnetizationLimited
    rotatingExciterWithDemagnetization(
    T_E=T_E,
    K_E=K_E,
    E_1=E_1,
    E_2=E_2,
    S_EE_1=S_EE_1,
    S_EE_2=S_EE_2,
    K_D=K_D,
    Efd0=VE0) annotation (Placement(transformation(extent={{124,30},{144,50}})));
  Modelica.Blocks.Math.Add3 add3_1(k3=-1)
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  BaseClasses.RectifierCommutationVoltageDrop rectifierCommutationVoltageDrop(
      K_C=K_C)
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
protected
  parameter Real VR0(fixed=false);
  parameter Real Efd0(fixed=false);
  parameter Real Ifd0(fixed=false);
  parameter Real VE0(fixed=false);
  parameter Real VFE0(fixed=false);
initial equation
  Ifd0 = XADIFD;
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
  V_REF = VR0/K_A + ECOMP0;
equation
  connect(imLeadLag.y, simpleLagLim.u)
    annotation (Line(points={{-31,40},{-18,40}}, color={0,0,127}));
  connect(limiter1.y, rotatingExciterWithDemagnetization.I_C)
    annotation (Line(points={{115,40},{122.75,40}}, color={0,0,127}));
  connect(ECOMP, imSimpleLag.u)
    annotation (Line(points={{-200,0},{-172,0}}, color={0,0,127}));
  connect(simpleLagLim.y, hV_GATE.n1) annotation (Line(points={{5,40},{12,40},{
          12,37},{18.5,37}}, color={0,0,127}));
  connect(VUEL, hV_GATE.n2) annotation (Line(points={{-130,-200},{-130,-40},{14,
          -40},{14,43},{18.5,43}}, color={0,0,127}));
  connect(imSimpleLag.y, DiffV.u2) annotation (Line(points={{-149,0},{-132,0},{
          -132,-6},{-122,-6}}, color={0,0,127}));
  connect(add3_1.y, imLeadLag.u)
    annotation (Line(points={{-67,40},{-54,40}}, color={0,0,127}));
  connect(DiffV.y, add3_1.u2) annotation (Line(points={{-99,0},{-96,0},{-96,40},
          {-90,40}}, color={0,0,127}));
  connect(VOTHSG, add3_1.u1) annotation (Line(points={{-200,90},{-150,90},{-96,
          90},{-96,48},{-90,48}}, color={0,0,127}));
  connect(derivative.y, add3_1.u3) annotation (Line(points={{19,0},{-94,0},{-94,
          32},{-90,32}}, color={0,0,127}));
  connect(derivative.u, rotatingExciterWithDemagnetization.V_FE) annotation (
      Line(points={{42,0},{82,0},{120,0},{120,33.75},{122.75,33.75}}, color={0,
          0,127}));
  connect(rotatingExciterWithDemagnetization.EFD,
    rectifierCommutationVoltageDrop.V_EX)
    annotation (Line(points={{145.25,40},{159,40}}, color={0,0,127}));
  connect(rectifierCommutationVoltageDrop.EFD, EFD) annotation (Line(points={{
          181,40},{190,40},{190,0},{210,0}}, color={0,0,127}));
  connect(hV_GATE.p, lV_GATE.n2) annotation (Line(points={{42.5,40},{50,40},{50,
          43},{56.5,43}}, color={0,0,127}));
  connect(VOEL, lV_GATE.n1) annotation (Line(points={{-70,-200},{-70,-200},{-70,
          -60},{50,-60},{50,37},{56.5,37}}, color={0,0,127}));
  connect(lV_GATE.p, limiter1.u)
    annotation (Line(points={{80.5,40},{92,40}}, color={0,0,127}));
  connect(XADIFD, rotatingExciterWithDemagnetization.XADIFD) annotation (Line(points={{80,-200},{80,-120},{134,-120},{134,28.75}}, color={0,0,127}));
  connect(XADIFD, rectifierCommutationVoltageDrop.XADIFD) annotation (Line(points={{80,-200},{80,-120},{170,-120},{170,29}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-200},{200,160}})),
    Icon(coordinateSystem(extent={{-200,-200},{200,160}}),
        graphics={Text(
          extent={{-186,-60},{-116,-80}},
          lineColor={28,108,200},
          textString="XADIFD"),Text(
          extent={{-100,152},{100,92}},
          lineColor={28,108,200},
          textString="ESAC1A")}),
    Documentation(info="<html>
<table cellspacing=\"1\" cellpadding=\"1\" border=\"1\"><tr>
<td><p>Model Name</p></td>
<td><p>ESAC1A</p></td>
</tr>
<tr>
<td><p>Reference</p></td>
<td><p>PSS/E Manual</p></td>
</tr>
<tr>
<td><p>Last update</p></td>
<td><p>September 2020</p></td>
</tr>
<tr>
<td><p>Author</p></td>
<td><p>Tin Rabuzin, SmarTS Lab, KTH Royal Institute of Technology</p></td>
</tr>
<tr>
<td><p>Contact</p></td>
<td><p><a href=\"mailto:vanfrl@rpi.edu\">vanfrl@rpi.edu</a></p></td>
</tr>
<tr>
<td><p>Model Verification</p></td>
<td><p>This model has been verified against PSS/E.</p></td>
</tr>
<tr>
<td><p>Description</p></td>
<td><p>IEEE Type AC1A Excitation System Model.</p></td>
</tr>
</table>
</html>"));
end ESAC1A;
