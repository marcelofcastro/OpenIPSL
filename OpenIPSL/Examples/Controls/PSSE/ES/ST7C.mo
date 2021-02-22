within OpenIPSL.Examples.Controls.PSSE.ES;
model ST7C "SMIB model example of GENROE with Excitation System ST7C"
  extends OpenIPSL.Examples.BaseClasses.SMIB;
  NewModels.Models.ST7C sT7C
    annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Constant PSS_off(k=0)
    annotation (Placement(transformation(extent={{-42,-36},{-50,-28}})));
  Modelica.Blocks.Sources.Constant VOEL(k=100)
    annotation (Placement(transformation(extent={{-20,-76},{-32,-64}})));
  Modelica.Blocks.Sources.Constant VUEL(k=-100)
    annotation (Placement(transformation(extent={{-20,-96},{-32,-84}})));
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
  Modelica.Blocks.Sources.Constant XadIfd_0(k=0)
    annotation (Placement(transformation(extent={{-96,-78},{-88,-70}})));
equation
  connect(sT7C.EFD, gENROE.EFD) annotation (Line(points={{-81,-50},{-100,-50},{-100,-10},{-92,-10}},
                                            color={0,0,127}));
  connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-92,10},{-100,10},{-100,30},{-40,30},{-40,10},{-46,10}},
                                                     color={0,0,127}));
  connect(gENROE.p, GEN1.p)
    annotation (Line(points={{-48,0},{-30,0}},         color={0,0,255}));
  connect(PSS_off.y, sT7C.VOTHSG) annotation (Line(points={{-50.4,-32},{-54,-32},
          {-54,-46},{-59,-46}}, color={0,0,127}));
  connect(XadIfd_0.y, sT7C.XADIFD) annotation (Line(points={{-87.6,-74},{-79,-74},
          {-79,-61}}, color={0,0,127}));
  connect(gENROE.ETERM, sT7C.ECOMP) annotation (Line(points={{-46,-6},{-40,-6},{
          -40,-50},{-59,-50}}, color={0,0,127}));
  connect(gENROE.EFD0, sT7C.EFD0) annotation (Line(points={{-46,-10},{-36,-10},{
          -36,-54},{-59,-54}}, color={0,0,127}));
  connect(VOEL.y, sT7C.VOEL) annotation (Line(points={{-32.6,-70},{-64,-70},{-64,
          -61}}, color={0,0,127}));
  connect(VOEL.y, sT7C.VOEL2) annotation (Line(points={{-32.6,-70},{-70,-70},{-70,
          -61}}, color={0,0,127}));
  connect(VOEL.y, sT7C.VOEL3) annotation (Line(points={{-32.6,-70},{-76,-70},{-76,
          -61}}, color={0,0,127}));
  connect(VUEL.y, sT7C.VUEL) annotation (Line(points={{-32.6,-90},{-61,-90},{-61,
          -61}}, color={0,0,127}));
  connect(VUEL.y, sT7C.VUEL2) annotation (Line(points={{-32.6,-90},{-67,-90},{-67,
          -61}}, color={0,0,127}));
  connect(VUEL.y, sT7C.VUEL3) annotation (Line(points={{-32.6,-90},{-73,-90},{-73,
          -61}}, color={0,0,127}));
  annotation (
experiment(StopTime=10));
end ST7C;