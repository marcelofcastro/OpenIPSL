within OpenIPSL.Electrical.Controls.PSSE.ES;
model ST6B "ST6B Excitation System [IEEE2005] - with PID regulator instead of PI"
  extends OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.BaseExciter;
  parameter OpenIPSL.Types.Time T_R=0.012 "Regulator input filter time constant";
  parameter OpenIPSL.Types.PerUnit K_PA=18.038 "Voltage regulator proportional gain (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_IA=45.094 "Voltage regulator integral gain";
  parameter OpenIPSL.Types.PerUnit K_DA=0.0 "Voltage regulator derivative gain";
  parameter OpenIPSL.Types.Time T_DA=1.0 "Voltage regulator derivative channel time constant";
  parameter OpenIPSL.Types.PerUnit V_AMAX=4.81 "Regulator output maximum limit";
  parameter OpenIPSL.Types.PerUnit V_AMIN=-3.85 "Regulator output minimum limit";
  parameter OpenIPSL.Types.PerUnit K_FF=1.0 "Pre-control gain of the inner loop field regulator";
  parameter OpenIPSL.Types.PerUnit K_M=1.0 "Forward gain of the inner loop field regulator";
  parameter OpenIPSL.Types.PerUnit K_CI=1.0577 "Exciter output current limit adjustment gain";
  parameter OpenIPSL.Types.PerUnit K_LR=17.33 "Exciter output current limiter gain";
  parameter OpenIPSL.Types.PerUnit I_LR=4.164 "Exciter current limit reference";
  parameter OpenIPSL.Types.PerUnit V_RMAX=4.81 "Voltage regulator output maximum limit";
  parameter OpenIPSL.Types.PerUnit V_RMIN=-3.85 "Voltage regulator output minimum limit";
  parameter OpenIPSL.Types.PerUnit K_G=1.0 "Feedback gain of the inner loop field voltage regulator";
  parameter OpenIPSL.Types.Time T_G=0.02 "Feedback time constant of the inner loop field voltage regulator (it must be greater than 0)";

  OpenIPSL.NonElectrical.Continuous.SimpleLag transducer(
    K=1,
    T=T_R,
    y_start=ECOMP0)
    annotation (Placement(transformation(extent={{-164,-10},{-144,10}})));
  Modelica.Blocks.Math.Add3 add_pss_oel(k3=-1)
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  OpenIPSL.NonElectrical.Logical.HV_GATE hV_GATE
    annotation (Placement(transformation(extent={{-60,-6},{-38,6}})));
  Modelica.Blocks.Interfaces.RealInput VOEL2
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-10,-200}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-110})));
  Modelica.Blocks.Math.Add Diff_oel(k2=-1)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Math.Add add_feedforward
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  OpenIPSL.NonElectrical.Logical.LV_GATE lV_GATE
    annotation (Placement(transformation(extent={{174,-6},{196,6}})));
  Modelica.Blocks.Math.Add current_error(k2=-1)
    annotation (Placement(transformation(extent={{86,-84},{106,-64}})));
  Modelica.Blocks.Nonlinear.Limiter limit_vI(uMax=Modelica.Constants.inf, uMin=
        V_RMIN)
    annotation (Placement(transformation(extent={{142,-84},{162,-64}})));
  Modelica.Blocks.Math.Gain current_gain(k=K_LR)
    annotation (Placement(transformation(extent={{114,-84},{134,-64}})));
  Modelica.Blocks.Sources.Constant const(k=K_CI*I_LR)
    annotation (Placement(transformation(extent={{54,-78},{74,-58}})));
  Modelica.Blocks.Nonlinear.Limiter limit_vI1(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{148,-10},{168,10}})));
  Modelica.Blocks.Math.Add errorEfd(k1=-1)
    annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  Modelica.Blocks.Math.Gain erroEfd_gain(k=K_M)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Nonlinear.Limiter limit_Va(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Continuous.FirstOrder vG_feedback(k=K_G, T=T_G,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=K_G*Efd0)
    annotation (Placement(transformation(extent={{172,32},{152,52}})));
  Modelica.Blocks.Math.Gain feedforward_gain(k=K_FF)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Math.Add3 pid_add
    annotation (Placement(transformation(extent={{22,78},{42,98}})));
  Modelica.Blocks.Math.Gain reg_p(k=K_PA) annotation (Placement(transformation(
          origin={0,88}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Continuous.Integrator reg_i(
    k=K_IA,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=VR0) annotation (Placement(transformation(
        origin={0,58},
        extent={{10,10},{-10,-10}},
        rotation=180)));
  Modelica.Blocks.Continuous.Derivative reg_d(
    k=K_DA,
    T=T_DA,
    y_start=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{-10,108},{10,128}})));
protected
  parameter Real VR0(fixed=false);
initial equation
  VR0 = if K_M<=Modelica.Constants.eps then Efd0/K_FF else Efd0*(1/K_M+K_G)/(1+K_FF/K_M);
  V_REF = ECOMP0;
equation
  connect(ECOMP, transducer.u)
    annotation (Line(points={{-200,0},{-166,0}}, color={0,0,127}));
  connect(transducer.y, DiffV.u2) annotation (Line(points={{-143,0},{-132,0},
          {-132,-6},{-122,-6}}, color={0,0,127}));
  connect(hV_GATE.p, add_pss_oel.u2)
    annotation (Line(points={{-39.375,0},{-34,0}}, color={0,0,127}));
  connect(DiffV.y, Diff_oel.u1) annotation (Line(points={{-99,0},{-96,0},{-96,6},
          {-92,6}}, color={0,0,127}));
  connect(VOEL, Diff_oel.u2) annotation (Line(points={{-70,-200},{-70,-160},{-96,
          -160},{-96,-6},{-92,-6}}, color={0,0,127}));
  connect(Diff_oel.y, hV_GATE.n1) annotation (Line(points={{-69,0},{-66,0},{-66,
          3},{-61.375,3}}, color={0,0,127}));
  connect(VOTHSG, add_pss_oel.u1) annotation (Line(points={{-200,90},{-44,90},{-44,
          8},{-34,8}}, color={0,0,127}));
  connect(VOEL2, add_pss_oel.u3) annotation (Line(points={{-10,-200},{-10,-160},
          {-44,-160},{-44,-8},{-34,-8}}, color={0,0,127}));
  connect(VUEL, hV_GATE.n2) annotation (Line(points={{-130,-200},{-130,-140},{-66,
          -140},{-66,-3},{-61.375,-3}}, color={0,0,127}));
  connect(EFD, lV_GATE.p)
    annotation (Line(points={{210,0},{194.625,0}}, color={0,0,127}));
  connect(limit_vI.y, lV_GATE.n2) annotation (Line(points={{163,-74},{172,-74},{
          172,-3},{172.625,-3}}, color={0,0,127}));
  connect(current_error.y, current_gain.u)
    annotation (Line(points={{107,-74},{112,-74}}, color={0,0,127}));
  connect(limit_vI.u, current_gain.y)
    annotation (Line(points={{140,-74},{135,-74}}, color={0,0,127}));
  connect(current_error.u1, const.y)
    annotation (Line(points={{84,-68},{75,-68}}, color={0,0,127}));
  connect(XADIFD, current_error.u2)
    annotation (Line(points={{80,-200},{80,-80},{84,-80}}, color={0,0,127}));
  connect(limit_vI1.y, lV_GATE.n1) annotation (Line(points={{169,0},{172,0},{172,
          3},{172.625,3}}, color={0,0,127}));
  connect(errorEfd.y, erroEfd_gain.u)
    annotation (Line(points={{83,0},{88,0}}, color={0,0,127}));
  connect(limit_vI1.u, add_feedforward.y)
    annotation (Line(points={{146,0},{141,0}}, color={0,0,127}));
  connect(limit_Va.y, errorEfd.u2)
    annotation (Line(points={{51,0},{54,0},{54,-6},{60,-6}}, color={0,0,127}));
  connect(erroEfd_gain.y, add_feedforward.u1) annotation (Line(points={{111,0},{
          114,0},{114,6},{118,6}}, color={0,0,127}));
  connect(vG_feedback.y, errorEfd.u1) annotation (Line(points={{151,42},{54,42},
          {54,6},{60,6}}, color={0,0,127}));
  connect(feedforward_gain.y, add_feedforward.u2) annotation (Line(points={{81,-30},
          {114,-30},{114,-6},{118,-6}}, color={0,0,127}));
  connect(vG_feedback.u, lV_GATE.p) annotation (Line(points={{174,42},{198,42},{
          198,0},{194.625,0}}, color={0,0,127}));
  connect(reg_d.y, pid_add.u1) annotation (Line(points={{11,118},{16,118},{16,96},
          {20,96}}, color={0,0,127}));
  connect(reg_p.y, pid_add.u2)
    annotation (Line(points={{11,88},{20,88}}, color={0,0,127}));
  connect(reg_i.y, pid_add.u3) annotation (Line(points={{11,58},{16,58},{16,80},
          {20,80}}, color={0,0,127}));
  connect(add_pss_oel.y, reg_d.u) annotation (Line(points={{-11,0},{-4,0},{-4,40},
          {-26,40},{-26,118},{-12,118}}, color={0,0,127}));
  connect(reg_p.u, reg_d.u) annotation (Line(points={{-12,88},{-26,88},{-26,118},
          {-12,118}}, color={0,0,127}));
  connect(reg_i.u, reg_d.u) annotation (Line(points={{-12,58},{-26,58},{-26,118},
          {-12,118}}, color={0,0,127}));
  connect(pid_add.y, limit_Va.u) annotation (Line(points={{43,88},{46,88},{46,40},
          {16,40},{16,0},{28,0}}, color={0,0,127}));
  connect(feedforward_gain.u, limit_Va.u) annotation (Line(points={{58,-30},{20,
          -30},{20,0},{28,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Text(
          extent={{18,-80},{46,-100}},
          lineColor={28,108,200},
          textString="VOEL 2"),Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="ST6B")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ST6B;