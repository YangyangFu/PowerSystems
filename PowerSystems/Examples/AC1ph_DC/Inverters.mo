within PowerSystems.Examples.AC1ph_DC;
package Inverters "Inverters 1 phase and DC"
  extends Modelica.Icons.ExamplesPackage;

  model Rectifier "Rectifier"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
      refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      t_change=0.1,
      t_duration=0.1,
      a_start=2,
      a_end=1)
         annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage vAC(use_vPhasor_in=true, V_nom=100,
      pol=0)
          annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    PowerSystems.AC1ph_DC.Inverters.Rectifier rectifier(redeclare model
        Rectifier =
          PowerSystems.AC1ph_DC.Inverters.Components.RectifierEquation (
          redeclare record Data =
          PowerSystems.Examples.Data.Semiconductors.IdealSC100V_10A))
      annotation (Placement(transformation(extent={{30,0},{10,20}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{40,0},{60,20}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0, V_nom=100)
      annotation (Placement(transformation(extent={{90,0},{70,20}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1 annotation (Placement(transformation(
            extent={{-80,0},{-100,20}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2 annotation (Placement(transformation(
            extent={{90,0},{110,20}})));
    PowerSystems.Common.Thermal.BdCondV bdCond(m=2) annotation (Placement(
          transformation(extent={{10,20},{30,40}})));

  equation
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{-60,10},{-50,10}}, color={0,0,255}));
    connect(ind.term_n, meterAC.term_p)
      annotation (Line(points={{-30,10},{-20,10}}, color={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (Line(points={{60,10},{70,10}}, color={0,0,255}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (Line(points={{0,10},{10,10}}, color={0,0,255}));
    connect(rectifier.DC, meterDC.term_p)
      annotation (Line(points={{30,10},{40,10}}, color={0,0,255}));
    connect(transPh.y, vAC.vPhasor_in)
      annotation (Line(points={{-80,30},{-64,30},{-64,20}}, color={0,0,127}));
    connect(grd1.term, vAC.neutral)
      annotation (Line(points={{-80,10},{-80,10}}, color={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (Line(points={{90,10},{90,10}}, color={0,0,255}));
    connect(rectifier.heat, bdCond.heat)
      annotation (Line(points={{20,20},{20,20}}, color={176,0,0}));
    annotation (
      Documentation(
              info="<html>
<p>1-phase rectifier. Compare 'equation' and 'modular' version.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Inverters\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        Interval=0.2e-3));
  end Rectifier;

  model InverterToLoad "Inverter to load"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
      refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(V_nom=100)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    PowerSystems.AC1ph_DC.Inverters.Inverter inverter(redeclare model Inverter =
        PowerSystems.AC1ph_DC.Inverters.Components.InverterEquation(redeclare
            record Data =
            PowerSystems.Examples.Data.Semiconductors.IdealSC100V_10A)
        "equation, with losses")
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC1ph_DC.Inverters.Select select(
      fType=PowerSystems.Types.SourceFrequency.Parameter,
      f=100,
      use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{10,-20},{30,0}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor ind(x=0.5, r=0.5,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    PowerSystems.Blocks.Signals.TransientPhasor vCtrl(
      t_change=0.05,
      t_duration=0.05,
      a_start=1.05,
      a_end=1.05,
      ph_end=0.5235987755983)
         annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd annotation (Placement(transformation(
            extent={{-80,-20},{-100,0}})));
    PowerSystems.Common.Thermal.BdCondV bdCond(m=2) annotation (Placement(
          transformation(extent={{-20,0},{0,20}})));

  equation
    connect(vDC.term, meterDC.term_p)
      annotation (Line(points={{-60,-10},{-50,-10}}, color={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (Line(points={{-30,-10},{-20,-10}}, color={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (Line(points={{0,-10},{10,-10}}, color={0,0,255}));
    connect(meterAC.term_n, ind.term)
      annotation (Line(points={{30,-10},{40,-10}}, color={0,0,255}));
    connect(select.theta_out, inverter.theta)
      annotation (Line(points={{-16,20},{-16,0}}, color={0,0,127}));
    connect(select.vPhasor_out,inverter.vPhasor)  annotation (Line(points={{-4,
            20},{-4,0}}, color={0,0,127}));
    connect(vCtrl.y,select.vPhasor_in)
      annotation (Line(points={{-30,50},{-4,50},{-4,40}}, color={0,0,127}));
    connect(grd.term, vDC.neutral)
      annotation (Line(points={{-80,-10},{-80,-10}}, color={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (Line(points={{-10,0},{-10,0}}, color={176,0,0}));
    annotation (
      Documentation(
              info="<html>
<p>1-phase inverter, feeding load at constant 100Hz with increasing amplitude.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Inverters\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        Interval=0.2e-3));
  end InverterToLoad;

  model InverterToGrid "Inverter to grid"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
      refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0,
      V_nom=100,
      v0=2)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC1ph_DC.Inverters.Inverter inverter(redeclare model Inverter =
        PowerSystems.AC1ph_DC.Inverters.Components.InverterEquation (
          redeclare record Data =
          PowerSystems.Examples.Data.Semiconductors.IdealSC100V_10A)
        "equation, with losses")
      annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
    PowerSystems.AC1ph_DC.Inverters.Select select(use_vPhasor_in=true)
                                   annotation (Placement(transformation(extent=
              {{-30,20},{-10,40}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{0,-20},{20,0}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{50,-20},{30,0}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage vAC(V_nom=100)
          annotation (Placement(transformation(extent={{80,-20},{60,0}})));
    PowerSystems.Blocks.Signals.TransientPhasor vCtrl(
      t_change=0.1,
      t_duration=0.1,
      a_start=1,
      a_end=1,
      ph_end=0.5235987755983)
         annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd  annotation (Placement(transformation(
            extent={{80,-20},{100,0}})));
    PowerSystems.Common.Thermal.BdCondV bdCond(m=2) annotation (Placement(
          transformation(extent={{-30,0},{-10,20}})));

  equation
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{60,-10},{50,-10}}, color={0,0,255}));
    connect(vDC.term, meterDC.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (Line(points={{20,-10},{30,-10}}, color={0,0,255}));
    connect(select.theta_out, inverter.theta) annotation (Line(points={{-26,20},
            {-26,0}}, color={0,0,127}));
    connect(select.vPhasor_out,inverter.vPhasor)  annotation (Line(points={{-14,
            20},{-14,0}}, color={0,0,127}));
    connect(vCtrl.y,select.vPhasor_in)
      annotation (Line(points={{-40,50},{-14,50},{-14,40}}, color={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (Line(points={{80,-10},{80,-10}}, color={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (Line(points={{-40,-10},{-30,-10}}, color={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (Line(points={{-10,-10},{0,-10}}, color={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (Line(points={{-20,0},{-20,0}}, color={176,0,0}));
    annotation (
      Documentation(
              info="<html>
<p>3-phase inverter, feeding into grid with increasing phase. Compare 'switch', 'equation' and 'modular' version.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Inverters\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        Interval=0.2e-3));
  end InverterToGrid;

  model InverterAvToGrid "Inverter to grid"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
      refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0,
      V_nom=100,
      v0=2)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC1ph_DC.Inverters.InverterAverage inverter(redeclare record
        Data=PowerSystems.Examples.Data.Semiconductors.IdealSC100V_10A)
      annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
    PowerSystems.AC1ph_DC.Inverters.Select select(use_vPhasor_in=true)
                                   annotation (Placement(transformation(extent=
              {{-30,20},{-10,40}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{0,-20},{20,0}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind(r={0.05,0.05},
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{50,-20},{30,0}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage vAC(V_nom=100)
          annotation (Placement(transformation(extent={{80,-20},{60,0}})));
    PowerSystems.Blocks.Signals.TransientPhasor vCtrl(
      t_change=0.1,
      t_duration=0.1,
      ph_end=0.5235987755983)
         annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd  annotation (Placement(transformation(
            extent={{80,-20},{100,0}})));
    PowerSystems.Common.Thermal.BdCondV bdCond(m=1) annotation (Placement(
          transformation(extent={{-30,0},{-10,20}})));

  equation
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{60,-10},{50,-10}}, color={0,0,255}));
    connect(vDC.term, meterDC.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (Line(points={{20,-10},{30,-10}}, color={0,0,255}));
    connect(select.theta_out, inverter.theta) annotation (Line(points={{-26,20},
            {-26,0}}, color={0,0,127}));
    connect(select.vPhasor_out,inverter.vPhasor)  annotation (Line(points={{-14,
            20},{-14,0}}, color={0,0,127}));
    connect(vCtrl.y,select.vPhasor_in)
      annotation (Line(points={{-40,50},{-14,50},{-14,40}}, color={0,0,127}));
    connect(vAC.neutral, grd.term)
      annotation (Line(points={{80,-10},{80,-10}}, color={0,0,255}));
    connect(meterDC.term_n, inverter.DC)
      annotation (Line(points={{-40,-10},{-30,-10}}, color={0,0,255}));
    connect(inverter.AC, meterAC.term_p)
      annotation (Line(points={{-10,-10},{0,-10}}, color={0,0,255}));
    connect(inverter.heat, bdCond.heat)
      annotation (Line(points={{-20,0},{-20,0}}, color={176,0,0}));
    annotation (
      Documentation(
              info="<html>
<p>1-phase inverter based on AVERAGED switch-equation, feeding into grid with increasing phase.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Inverters\">up users guide</a></p>
</html>"),
      experiment(
        StopTime=0.2,
        Interval=0.2e-3));
  end InverterAvToGrid;

  model Chopper "Chopper"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
      refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(V_nom=100)
          annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDCin(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
    PowerSystems.AC1ph_DC.Inverters.Chopper chopper(redeclare model Chopper =
      PowerSystems.AC1ph_DC.Inverters.Components.ChopperModular(redeclare
            record Data =
               PowerSystems.Examples.Data.Semiconductors.IdealSC100V_10A))
      annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDCout(av=true, tcst=0.1,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    PowerSystems.Blocks.Signals.Transient vDCoutCtrl(
      t_change=0,
      t_duration=0.2,
      s_start=0,
      s_end=0.7)                             annotation (Placement(
          transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor load(x=0.5, r=0.5,
      V_nom=100,
      S_nom=1e3)
      annotation (Placement(transformation(extent={{60,-20},{80,0}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd annotation (Placement(transformation(
            extent={{-80,-20},{-100,0}})));
    PowerSystems.Common.Thermal.BdCondV bdCond(m=2) annotation (Placement(
          transformation(extent={{-10,0},{10,20}})));

  equation
    connect(grd.term, vDC.neutral) annotation (Line(points={{-80,-10},{-80,-10}},
          color={0,0,255}));
    connect(vDC.term, meterDCin.term_p) annotation (Line(points={{-60,-10},{-40,
            -10}}, color={0,0,255}));
    connect(meterDCin.term_n, chopper.DCin) annotation (Line(points={{-20,-10},
            {-10,-10}}, color={0,0,255}));
    connect(chopper.DCout, meterDCout.term_p)
      annotation (Line(points={{10,-10},{20,-10}}, color={0,0,255}));
    connect(meterDCout.term_n, load.term)
      annotation (Line(points={{40,-10},{60,-10}}, color={0,0,255}));
    connect(vDCoutCtrl.y,chopper.vDC)  annotation (Line(points={{-20,30},{6,30},
            {6,0}}, color={0,0,127}));
    connect(chopper.heat, bdCond.heat)
      annotation (Line(points={{0,0},{0,0}}, color={176,0,0}));
    annotation (
      Documentation(
              info="<html>
<p>One quadrant chopper.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Inverters\">up users guide</a></p>
</html>
"),   experiment(
        StopTime=0.2,
        Interval=0.2e-3));
  end Chopper;

  annotation (preferredView="info",
Documentation(info="<html>
<p>Comparison of different one-phase rectifier and inverter models.</p>
<p><a href=\"modelica://PowerSystems.Examples\">up users guide</a></p>
</html>
"));
end Inverters;
