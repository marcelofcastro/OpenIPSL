within OpenIPSL.Electrical.Controls.PSSE.ES;
model IEEET3 "IEEE Type 3 Excitation System [IEEE1981]"
  extends OpenIPSL.Electrical.Controls.PSSE.ES.BaseClasses.BaseExciter;
  import Modelica.ComplexMath.j;
  import Modelica.ComplexMath.'abs';
  parameter OpenIPSL.Types.Time T_R = 0.0 "Regulator input filter time constant";
  parameter OpenIPSL.Types.PerUnit K_A = 120 "Voltage regulator gain";
  parameter OpenIPSL.Types.Time T_A = 0.15 "Voltage regulator time constant";
  parameter OpenIPSL.Types.PerUnit V_RMAX = 1.2 "Maximum regulator output";
  parameter OpenIPSL.Types.PerUnit V_RMIN = -1.2 "Minimum regulator output";
  parameter OpenIPSL.Types.Time T_E = 0.5 "Exciter field time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_F = 0.02 "Rate feedback excitation system stabilizer gain";
  parameter OpenIPSL.Types.Time T_F= 0.53 "Rate feedback time constant (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_P=1.19 "Potential circuit (voltage) gain coefficient (it must be greater than 0)";
  parameter OpenIPSL.Types.PerUnit K_I=1.86 "Compound circuit (current) gain coefficient";
  parameter OpenIPSL.Types.PerUnit V_BMAX=2.82 "Maximum available exciter voltage";
  parameter OpenIPSL.Types.PerUnit K_E=1.0 "Exciter field proportional constant";

  Modelica.Blocks.Math.Product mult
    annotation (Placement(transformation(extent={{2,-108},{22,-88}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag regulator(
    K=K_A,
    T=T_A,
    y_start=VR0) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={-10,0})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Blocks.Math.Add add_sat
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  OpenIPSL.Interfaces.PwPin Gen_terminal annotation (Placement(transformation(
          extent={{-180,120},{-160,140}}), iconTransformation(extent={{-100,70},{-80,90}})));
  OpenIPSL.Interfaces.PwPin Bus annotation (Placement(transformation(extent={{180,120},{200,140}}),
                                  iconTransformation(extent={{80,70},{100,90}})));
  Modelica.Blocks.Math.Add3 additional_signals
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLag transducer(
    K=1,
    T=T_R,
    y_start=ECOMP0)
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Modelica.Blocks.Math.Add add_els annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-92,-104})));
  Modelica.Blocks.Math.Feedback trans_reduct_feedback
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Modelica.Blocks.Continuous.Derivative tran_damping_branch(
    k=K_F,
    y_start=0,
    T=T_F,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start=Efd0)
    annotation (Placement(transformation(extent={{0,-60},{-20,-40}})));
  Modelica.Blocks.Continuous.TransferFunction excitation_transformer(
    b={1},
    a={T_E,K_E},
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start={Efd0*K_E},
    y_start=Efd0)
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Modelica.Blocks.Sources.RealExpression thevenin_voltage(y=V_THEV)
    annotation (Placement(transformation(extent={{-38,-96},{-18,-76}})));
  Modelica.Blocks.Sources.RealExpression self_exc_account(y=SEA)
    annotation (Placement(transformation(extent={{-38,-122},{-18,-102}})));
  Modelica.Blocks.Nonlinear.VariableLimiter limit_vb
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression low_value
    annotation (Placement(transformation(extent={{60,-38},{80,-18}})));
  Modelica.Blocks.Sources.RealExpression high_value(y=VMAX)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
protected
  Complex V_T;
  Complex I_T;
  Real V_THEV;
  Real SEA;
  Real VMAX;
  Real A;
  parameter Real Ifd0(fixed=false);
  parameter Real VR0(fixed=false);
  parameter Real VB0(fixed=false);
  parameter Real A0(fixed=false);
  parameter Real SEA0(fixed=false);
  parameter Real V_THEV0(fixed=false);
initial equation
  Ifd0 = XADIFD;
  V_THEV0 = 'abs'(K_P*V_T + j*K_I*I_T);
  A0 = (0.78*Ifd0/V_THEV0)^2;
  SEA0 = if A0 > 1.0 then 0.0 else sqrt(1-A0);
  VB0 = if A0 > 1.0 then 0.0 else Efd0*K_E;
  VR0 = VB0 - V_THEV0*SEA0;
  V_REF = VR0/K_A + ECOMP;
equation
  A = (0.78*XADIFD/V_THEV)^2;
  SEA = if A > 1.0 then 0.0 else sqrt(1-A);
  VMAX = if A > 1.0 then 0.0+Modelica.Constants.eps else V_BMAX;
  V_THEV = 'abs'(K_P*V_T + j*K_I*I_T);
  V_T = Gen_terminal.vr + j*Gen_terminal.vi;
  I_T = Gen_terminal.ir + j*Gen_terminal.ii;
  connect(ECOMP, transducer.u) annotation (Line(points={{-200,0},{-172,0},{
          -172,0}}, color={0,0,127}));
  connect(transducer.y, DiffV.u2) annotation (Line(points={{-149,0},{-132,0},
          {-132,-6},{-122,-6}}, color={0,0,127}));
  connect(DiffV.y, additional_signals.u2)
    annotation (Line(points={{-99,0},{-82,0},{-82,0}}, color={0,0,127}));
  connect(VOTHSG, additional_signals.u1) annotation (Line(points={{-200,90},{-92,
          90},{-92,8},{-82,8}}, color={0,0,127}));
  connect(Gen_terminal, Bus) annotation (Line(points={{-170,130},{190,130}},
                 color={0,0,255}));
  connect(VUEL, add_els.u1) annotation (Line(points={{-130,-200},{-130,-130},{-98,
          -130},{-98,-116}}, color={0,0,127}));
  connect(VOEL, add_els.u2) annotation (Line(points={{-70,-200},{-72,-200},{-72,
          -130},{-86,-130},{-86,-116}}, color={0,0,127}));
  connect(additional_signals.u3, add_els.y)
    annotation (Line(points={{-82,-8},{-92,-8},{-92,-93}}, color={0,0,127}));
  connect(additional_signals.y, trans_reduct_feedback.u1)
    annotation (Line(points={{-59,0},{-50,0}}, color={0,0,127}));
  connect(trans_reduct_feedback.y, regulator.u)
    annotation (Line(points={{-33,0},{-22,0}}, color={0,0,127}));
  connect(regulator.y, limiter.u)
    annotation (Line(points={{1,0},{14,0}}, color={0,0,127}));
  connect(limiter.y, add_sat.u1)
    annotation (Line(points={{37,0},{46,0},{46,6},{58,6}}, color={0,0,127}));
  connect(tran_damping_branch.y, trans_reduct_feedback.u2)
    annotation (Line(points={{-21,-50},{-42,-50},{-42,-8}}, color={0,0,127}));
  connect(excitation_transformer.y, EFD)
    annotation (Line(points={{161,0},{210,0}}, color={0,0,127}));
  connect(tran_damping_branch.u, EFD) annotation (Line(points={{2,-50},{180,-50},
          {180,0},{210,0}}, color={0,0,127}));
  connect(mult.y, add_sat.u2) annotation (Line(points={{23,-98},{46,-98},{46,-6},
          {58,-6}}, color={0,0,127}));
  connect(mult.u1, thevenin_voltage.y) annotation (Line(points={{0,-92},{-8,-92},
          {-8,-86},{-17,-86}}, color={0,0,127}));
  connect(mult.u2, self_exc_account.y) annotation (Line(points={{0,-104},{-8,-104},
          {-8,-112},{-17,-112}}, color={0,0,127}));
  connect(excitation_transformer.u, limit_vb.y)
    annotation (Line(points={{138,0},{121,0}}, color={0,0,127}));
  connect(add_sat.y, limit_vb.u)
    annotation (Line(points={{81,0},{98,0}}, color={0,0,127}));
  connect(limit_vb.limit2, low_value.y) annotation (Line(points={{98,-8},{90,-8},
          {90,-28},{81,-28}}, color={0,0,127}));
  connect(high_value.y, limit_vb.limit1)
    annotation (Line(points={{81,30},{90,30},{90,8},{98,8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-180,-180},{200,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-80,90},{-20,70}},
          lineColor={0,0,255},
          textString="GenT"),  Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          textString="IEEET3"),
                  Text(
          extent={{40,90},{80,70}},
          lineColor={0,0,255},
          textString="Bus")}),
    Documentation(info="<html>IEEE Type 3 Exciter Model.</html>",
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
end IEEET3;