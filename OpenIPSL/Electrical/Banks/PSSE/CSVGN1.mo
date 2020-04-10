within OpenIPSL.Electrical.Banks.PSSE;
model CSVGN1 "STATC SHUNT COMPENSATOR MODEL"
  outer OpenIPSL.Electrical.SystemBase SysData
    "Must add this line in all models";
  parameter SI.ApparentPower S_b(displayUnit="MVA")=SysData.S_b "System base power"
    annotation (Dialog(group="Power flow data"));
  parameter SI.ActivePower P_0(displayUnit="MW")=1e6 "Initial active power"
    annotation (Dialog(group="Power flow data"));
  parameter SI.ReactivePower Q_0(displayUnit="Mvar")=0 "Initial reactive power"
    annotation (Dialog(group="Power flow data"));
  parameter SI.PerUnit v_0=1 "Initial voltage magnitude at terminal bus"
    annotation (Dialog(group="Power flow data"));
  parameter SI.Conversions.NonSIunits.Angle_deg angle_0=0 "Initial voltage angle"
    annotation (Dialog(group="Power flow data"));
  parameter SI.PerUnit ra=0 "amature resistance" annotation (Dialog(group="Plant parameters", enable = false));
  parameter SI.PerUnit x1d=9999 "d-axis transient reactance, pu, should be set to 9999" annotation (Dialog(group="Plant parameters", enable = false));
  parameter Real K=1 annotation (Dialog(group="Device parameters"));
  parameter SI.Time T1=0 annotation (Dialog(group="Device parameters"));
  parameter SI.Time T2=0 annotation (Dialog(group="Device parameters"));
  parameter SI.Time T3=0 annotation (Dialog(group="Device parameters"));
  parameter SI.Time T4=0 annotation (Dialog(group="Device parameters"));
  parameter SI.Time T5=0 annotation (Dialog(group="Device parameters"));
  parameter SI.ReactivePower RMIN(displayUnit="Mvar")=0 "Reactor minmum var output" annotation (Dialog(group="Device parameters"));
  parameter SI.PerUnit VMAX=0.5 annotation (Dialog(group="Device parameters"));
  parameter SI.PerUnit VMIN=0 annotation (Dialog(group="Device parameters"));
  parameter SI.ReactivePower CBASE(displayUnit="Mvar")=100e6 "Capacitor output" annotation (Dialog(group="Device parameters"));
  parameter SI.ApparentPower MBASE(displayUnit="MVA")=100e6 "Power range of SVC" annotation (Dialog(group="Device parameters"));
  SI.PerUnit v(start=v_0) "Bus voltage magnitude";
  SI.Angle anglev(start=anglev_rad) " Bus voltage angle";
  //Real pe "electric power";
  SI.PerUnit P;
  SI.PerUnit Q;
  SI.PerUnit vd(start=vd0) "voltage direct axis";
  SI.PerUnit vq(start=vq0) "voltage quadrature axis";
  SI.PerUnit id(start=id0) "current direct axis";
  SI.PerUnit iq(start=iq0) "current quadrature axis";
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{76,-10},{96,10}})));
  Modelica.Blocks.Interfaces.RealOutput Y(start=Y0)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput V
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  Modelica.Blocks.Sources.Constant const(k=MBASE/S_b)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.Constant const1(k=CBASE/S_b)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  OpenIPSL.NonElectrical.Continuous.SimpleLagLim LagLim(
    outMin=RMIN/MBASE,
    outMax=1,
    T=T5,
    K=1,
    y_start=k50)
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Blocks.Sources.Constant const2(k=Vref)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-68,32})));
  OpenIPSL.Interfaces.PwPin p(
    vr(start=vr0),
    vi(start=vi0),
    ir(start=ir0),
    ii(start=ii0))
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  NonElectrical.Continuous.LeadLag leadLag(
    K=K,
    T1=T1+C.eps,
    T2=T3+C.eps,
    y_start=k30)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  NonElectrical.Continuous.LeadLagLim leadLagLim(
    K=K,
    T1=T2+C.eps,
    T2=T4+C.eps,
    outMax=VMAX,
    outMin=VMIN,
    y_start=k30)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Interfaces.RealInput VOTHSG
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Math.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-78,-40},{-58,-20}})));
protected 
  parameter SI.PerUnit p0=P_0/S_b "Active power pu on system base";
  parameter SI.PerUnit q0=Q_0/S_b "Reactive power pu on system base";
  parameter SI.Angle anglev_rad=SI.Conversions.from_deg(angle_0);
  parameter SI.PerUnit Y0=q0/(v_0*v_0) "Capacitor output";
  parameter SI.PerUnit vr0=v_0*cos(anglev_rad) "Initialization";
  parameter SI.PerUnit vi0=v_0*sin(anglev_rad) "Initialization";
  parameter SI.PerUnit ir0=(p0*vr0 + q0*vi0)/(vr0^2 + vi0^2) "Initialization";
  parameter SI.PerUnit ii0=(p0*vi0 - q0*vr0)/(vr0^2 + vi0^2) "Initialization";
  parameter SI.Angle delta0=atan2(vi0 + ra*ii0 + x1d*ir0, vr0 + ra*ir0 - x1d*ii0) "Initialization";
  parameter SI.PerUnit vd0=vr0*cos(C.pi/2 - delta0) - vi0*sin(C.pi/2 - delta0) "Initialization";
  parameter SI.PerUnit vq0=vr0*sin(C.pi/2 - delta0) + vi0*cos(C.pi/2 - delta0) "Initialization";
  parameter SI.PerUnit id0=ir0*cos(C.pi/2 - delta0) - ii0*sin(C.pi/2 - delta0) "Initialization";
  parameter SI.PerUnit iq0=ir0*sin(C.pi/2 - delta0) + ii0*cos(C.pi/2 - delta0) "Initialization";
  parameter SI.PerUnit k50(fixed=false);
  parameter SI.PerUnit k30(fixed=false);
  parameter SI.PerUnit k0(fixed=false);
  parameter SI.PerUnit Vref(fixed=false);
initial equation 
  k50 = (CBASE/S_b - Y0)/(MBASE/S_b);
  k30 = k50;
  k0 = k30/K;
  Vref = V - k0;
equation 
  v = sqrt(p.vr^2 + p.vi^2);
  anglev = atan2(p.vi, p.vr);
  [p.ir; p.ii] = -[sin(delta0), cos(delta0); -cos(delta0), sin(delta0)]*[id; iq];
  [p.vr; p.vi] = [sin(delta0), cos(delta0); -cos(delta0), sin(delta0)]*[vd; vq];
  vq = id/Y;
  vd = -iq/Y;
  -P = p.vr*p.ir + p.vi*p.ii;
  -Q = p.vi*p.ir - p.vr*p.ii;
  connect(const1.y, add.u1) annotation (Line(
      points={{51,40},{70,40},{70,6},{74,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, Y) annotation (Line(
      points={{97,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, add.u2) annotation (Line(
      points={{67,0},{70,0},{70,-6},{74,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V, add1.u2) annotation (Line(
      points={{-120,50},{-90,50},{-90,-6},{-80,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, product1.u1) annotation (Line(
      points={{-19,40},{0,40},{0,20},{40,20},{40,6},{44,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(leadLag.y, leadLagLim.u)
    annotation (Line(points={{-19,0},{-14,0}}, color={0,0,127}));
  connect(leadLagLim.y, LagLim.u)
    annotation (Line(points={{9,0},{14,0}}, color={0,0,127}));
  connect(LagLim.y, product1.u2)
    annotation (Line(points={{37,0},{40,0},{40,-6},{44,-6}}, color={0,0,127}));
  connect(VOTHSG, add2.u2) annotation (Line(points={{-120,-50},{-90,-50},{-90,-36},
          {-80,-36}}, color={0,0,127}));
  connect(add1.y, add2.u1) annotation (Line(points={{-57,0},{-54,0},{-54,-14},{-90,
          -14},{-90,-24},{-80,-24}}, color={0,0,127}));
  connect(add2.y, leadLag.u) annotation (Line(points={{-57,-30},{-48,-30},{-48,0},
          {-42,0}}, color={0,0,127}));
  connect(const2.y, add1.u1) annotation (Line(points={{-79,32},{-86,32},{-86,6},
          {-80,6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
          lineColor={0,0,255}),Text(
          extent={{-46,20},{40,-26}},
          lineColor={0,0,255},
          textString="CSVGN1"),Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          textString="%name")}));
end CSVGN1;