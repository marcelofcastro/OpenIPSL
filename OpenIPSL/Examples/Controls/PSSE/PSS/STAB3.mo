within OpenIPSL.Examples.Controls.PSSE.PSS;
model STAB3
  "Simple Machine Infinite Bus with Machine, Governor and Excitation system"
  extends OpenIPSL.Examples.SMIBpartial;
  OpenIPSL.Electrical.Machines.PSSE.GENSAL gENSAL(
    Xppd=0.2,
    Xppq=0.2,
    Xl=0.12,
    angle_0=4.05,
    Tpd0=6.7000,
    Tppd0=0.28000E-01,
    Tppq0=0.35000E-01,
    H=4.4100,
    D=0,
    Xd=1.2200,
    Xq=0.76000,
    Xpd=0.29700,
    S10=0.18600,
    S12=0.802,
    M_b=100000000,
    P_0=39999950,
    Q_0=5416571,
    v_0=1) annotation (Placement(transformation(extent={{-106,-12},{-78,14}})));
  OpenIPSL.Electrical.Controls.PSSE.TG.HYGOV hYGOV(VELM=0.02, G_MAX=0.415)
    annotation (Placement(transformation(
        extent={{-19,-14},{19,14}},
        rotation=180,
        origin={-83,30})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX sCRX(
    T_AT_B=0.01,
    T_B=10,
    K=100,
    T_E=0.05,
    E_MIN=0,
    E_MAX=5,
    r_cr_fd=0,
    C_SWITCH=false) annotation (Placement(transformation(
        extent={{-18,-16},{18,16}},
        rotation=180,
        origin={-94,-36})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(
        transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={-68,-34})));
equation
  connect(sCRX.VUEL, const.y) annotation (Line(
      points={{-82.3,-20},{-71.67,-20},{-71.67,-34},{-70.2,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sCRX.VOEL, const.y) annotation (Line(
      points={{-87.7,-20},{-71.67,-20},{-71.67,-34},{-70.2,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gENSAL.EFD0, sCRX.EFD0) annotation (Line(
      points={{-76.6,-5.5},{-74,-5.5},{-74,-26.2222},{-76,-26.2222}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gENSAL.XADIFD, sCRX.XADIFD) annotation (Line(points={{-76.88,-10.7},
          {-70,-10.7},{-70,-31.5556},{-76,-31.5556}}, color={0,0,127}));
  connect(sCRX.ECOMP, gENSAL.ETERM) annotation (Line(points={{-76,-37.7778},
          {-66,-37.7778},{-66,-2.9},{-76.6,-2.9}},color={0,0,127}));
  connect(gENSAL.SPEED, hYGOV.SPEED) annotation (Line(points={{-76.6,10.1},{
          -58,10.1},{-58,23},{-64.475,23}}, color={0,0,127}));
  connect(gENSAL.PMECH0, hYGOV.PMECH0) annotation (Line(points={{-76.6,7.5},
          {-64,7.5},{-64,10},{-48,10},{-48,37},{-64.475,37}},color={0,0,127}));
  connect(hYGOV.PMECH, gENSAL.PMECH) annotation (Line(points={{-102.95,30},{
          -112,30},{-112,7.5},{-108.8,7.5}}, color={0,0,127}));
  connect(gENSAL.EFD, sCRX.EFD) annotation (Line(points={{-108.8,-5.5},{-116,
          -5.5},{-116,-37.7778},{-112.9,-37.7778}}, color={0,0,127}));
  connect(sCRX.VOTHSG, const.y) annotation (Line(points={{-76,-45.7778},{-74,-45.7778},
          {-74,-36},{-71.67,-36},{-71.67,-34},{-70.2,-34}}, color={0,0,127}));
  connect(gENSAL.p, GEN1.p) annotation (Line(points={{-78,1},{-58.3,1},{-58.3,
          0},{-40,0}}, color={0,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{
            100,80}})),
    Icon(coordinateSystem(extent={{-100,-120},{100,80}})),
experiment(StopTime=10));
end STAB3;
