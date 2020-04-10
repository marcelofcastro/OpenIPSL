within OpenIPSL.Examples.Banks.PSSE;
model CSVGN1
 extends OpenIPSL.Examples.SMIBpartial2;
 OpenIPSL.Electrical.Machines.PSSE.GENSAL gENSAL(
    Tpd0=5,
    Tppd0=0.07,
    Tppq0=0.09,
    H=4.28,
    D=0,
    Xd=1.84,
    Xq=1.75,
    Xpd=0.41,
    Xppd=0.2,
    Xl=0.12,
    S10=0.11,
    S12=0.39,
    angle_0=4.038907,
    Xppq=0.2,
    R_a=0,
    M_b=100000000,
    P_0=40000000,
    Q_0=4402877,
    v_0=1) annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
 OpenIPSL.Electrical.Banks.PSSE.CSVGN1 cSVGN1(
    K=5,
    T1=0.01,
    T2=0,
    T3=10,
    T4=0,
    T5=0.05,
    VMAX=1.05,
    VMIN=0,
    CBASE=40000000,
    MBASE=80000000,
    v_0=1,
    angle_0=-0.29,
    P_0=0,
    Q_0=6009897)
 annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={40,68})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=SHUNT.V)
    annotation (Placement(transformation(extent={{-6,38},{14,58}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-6,62},{14,82}})));
equation
 connect(gENSAL.PMECH, gENSAL.PMECH0) annotation (Line(points={{-104,10},{-112,
          10},{-112,26},{-54,26},{-54,10},{-58,10}}, color={0,0,127}));
    connect(gENSAL.EFD, gENSAL.EFD0) annotation (Line(points={{-104,-10},{-112,-10},
          {-112,-30},{-54,-30},{-54,-10},{-58,-10}}, color={0,0,127}));
    connect(gENSAL.p, GEN1.p) annotation (Line(points={{-60,0},{-60,0},{-40,0}}, color={0,0,255}));
 connect(cSVGN1.p, SHUNT.p) annotation (Line(points={{40,58},{40,30}}, color={0,0,255}));
  connect(cSVGN1.V, realExpression.y)
    annotation (Line(points={{28,63},{20,63},{20,48},{15,48}},
                                               color={0,0,127}));
  connect(const.y, cSVGN1.VOTHSG) annotation (Line(points={{15,72},{22,72},{22,
          73},{28,73}}, color={0,0,127}));
    annotation (experiment(StopTime=10), uses(Modelica(version="3.2.2")));
end CSVGN1;
