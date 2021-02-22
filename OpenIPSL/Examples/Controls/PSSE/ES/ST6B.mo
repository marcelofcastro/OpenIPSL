within OpenIPSL.Examples.Controls.PSSE.ES;
model ST6B "SMIB model example of GENROE with Excitation System ST6B"
  extends OpenIPSL.Examples.BaseClasses.SMIB;
  Modelica.Blocks.Sources.Constant PSS_off(k=0)
    annotation (Placement(transformation(extent={{-20,-78},{-28,-70}})));
  Modelica.Blocks.Sources.Constant VOEL(k=0)
    annotation (Placement(transformation(extent={{-46,-40},{-58,-28}})));
  Modelica.Blocks.Sources.Constant VUEL(k=-100)
    annotation (Placement(transformation(extent={{-46,-58},{-58,-46}})));
  OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE(
    Tpd0=5,
    Tppd0=0.07,
    Tpq0=0.9,
    Tppq0=0.09,
    H=4.28,
    D=0,
    Xd=1.84,
    Xq=1.75,
    Xpd=0.41,
    Xpq=0.6,
    Xppd=0.2,
    Xl=0.12,
    S10=0.11,
    S12=0.39,
    angle_0=0.070492225331847,
    Xppq=0.2,
    M_b=100000000,
    P_0=40000000,
    Q_0=5416582,
    v_0=1) annotation (Placement(transformation(extent={{-88,-20},{-48,20}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.ST6B sT6B
    annotation (Placement(transformation(extent={{-60,-60},{-80,-80}})));
equation
  connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-92,10},{-100,10},{-100,30},{-40,30},{-40,10},{-46,10}},
                                                     color={0,0,127}));
  connect(gENROE.p, GEN1.p)
    annotation (Line(points={{-48,0},{-30,0}},         color={0,0,255}));
  connect(sT6B.EFD, gENROE.EFD) annotation (Line(points={{-81,-70},{-98,-70},
          {-98,-10},{-92,-10}}, color={0,0,127}));
  connect(PSS_off.y, sT6B.VOTHSG)
    annotation (Line(points={{-28.4,-74},{-59,-74}}, color={0,0,127}));
  connect(gENROE.EFD0, sT6B.EFD0) annotation (Line(points={{-46,-10},{-38,
          -10},{-38,-66},{-59,-66}}, color={0,0,127}));
  connect(gENROE.ETERM, sT6B.ECOMP) annotation (Line(points={{-46,-6},{-36,
          -6},{-36,-70},{-59,-70}}, color={0,0,127}));
  connect(gENROE.XADIFD, sT6B.XADIFD) annotation (Line(points={{-46,-18},{
          -42,-18},{-42,-24},{-78,-24},{-78,-59}}, color={0,0,127}));
  connect(VOEL.y, sT6B.VOEL2) annotation (Line(points={{-58.6,-34},{-73,-34},
          {-73,-59}}, color={0,0,127}));
  connect(VOEL.y, sT6B.VOEL) annotation (Line(points={{-58.6,-34},{-70,-34},
          {-70,-59}}, color={0,0,127}));
  connect(VUEL.y, sT6B.VUEL) annotation (Line(points={{-58.6,-52},{-66,-52},
          {-66,-59}}, color={0,0,127}));
  annotation (
experiment(StopTime=10));
end ST6B;
