within AixLib.Media;
package Water "Package with model for liquid water with constant density"
   extends Modelica.Media.Water.ConstantPropertyLiquidWater(
     final cv_const=cp_const,
     p_default=300000,
     reference_p=300000,
     reference_T=273.15,
     reference_X={1});
  // cp_const and cv_const have been made final because the model sets u=h.
  extends Modelica.Icons.Package;

  // For the ThermodynamicState, we set start values to the default medium states
  // to provide better guesses for solvers
  record extends ThermodynamicState(
      T(start=T_default),
      p(start=p_default)) "Thermodynamic state variables"
  end ThermodynamicState;

  redeclare model BaseProperties "Base properties"
    Modelica.SIunits.Temperature T "Temperature of medium";
    InputAbsolutePressure p "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.SIunits.SpecificInternalEnergy u
      "Specific internal energy of medium";
    Modelica.SIunits.Density d=d_const "Density of medium";
    Modelica.SIunits.MassFraction[nX] X={1}
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.SIunits.SpecificHeatCapacity R=0
      "Gas constant (of mixture if applicable)";
    final Modelica.SIunits.MolarMass MM=MM_const
      "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=true
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T)
      "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

    // Local connector definition, used for equation balancing check
    connector InputAbsolutePressure = input Modelica.SIunits.AbsolutePressure
      "Pressure as input signal connector";
    connector InputSpecificEnthalpy = input Modelica.SIunits.SpecificEnthalpy
      "Specific enthalpy as input signal connector";
    connector InputMassFraction = input Modelica.SIunits.MassFraction
      "Mass fraction as input signal connector";

  equation
    assert(T >= T_min and T <= T_max, "
Temperature T (= " + String(T) + " K) is not
in the allowed range (" + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \"" + mediumName + "\".
");

    h = cp_const*(T-reference_T);
    u = h;
    state.T = T;
    state.p = p;
    annotation (Documentation(info="<html>
    <p>
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>u = cv_const*(T - reference_T)</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    </p>
</html>"));
  end BaseProperties;

function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := cp_const*(T-reference_T);

annotation (smoothOrder=5,
Documentation(info="<html>
<p>
Enthalpy of the water.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2014 by Michael Wetter:<br/>
First implementation.
This function is used by
<a href=\"modelica://AixLib.Fluid.MixingVolumes.MixingVolumeMoistAir\">
AixLib.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This medium package models liquid water.
</p>
<p>
The mass density is computed using a constant value of <i>995.586</i> kg/s.
For a medium model in which the density is a function of temperature, use
<a href=\"modelica://AixLib.Media.Specialized.Water.TemperatureDependentDensity\">
AixLib.Media.Specialized.Water.TemperatureDependentDensity</a> which may have considerably higher computing time.
</p>
<p>
For the specific heat capacities at constant pressure and at constant volume,
a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C
is used.
The figure below shows the relative error of the specific heat capacity that
is introduced by this simplification.
</p>
<p align=\"center\">
<img src=\"modelica://AixLib/Resources/Images/Media/Water/plotCp.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
Water is modeled as an incompressible liquid.
There are no phase changes.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect</code> attribute on pressure as this caused
<a href=\"modelica://AixLib.Examples.Tutorial.SpaceCooling.System3\">
AixLib.Examples.Tutorial.SpaceCooling.System3</a>
to fail with the error message
\"differentiated if-then-else was not continuous\".
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Reimplemented media based on
<a href=\"https://github.com/iea-annex60/modelica-annex60/blob/446aa83720884052476ad6d6d4f90a6a29bb8ec9/AixLib/Media/Water.mo\">446aa83</a>.
</li>
<li>
November 15, 2013, by Michael Wetter:<br/>
Complete new reimplementation because the previous version
had the option to add a compressibility to the medium, which
has never been used.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{16,-28},{32,-42},{26,-48},{10,-36},{16,-28}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={95,95,95}),
        Polygon(
          points={{10,34},{26,44},{30,36},{14,26},{10,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-82,52},{24,-54}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{22,82},{80,24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{20,-30},{78,-88}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95})}));
end Water;