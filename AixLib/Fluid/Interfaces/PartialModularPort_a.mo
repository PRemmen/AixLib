within AixLib.Fluid.Interfaces;
partial model PartialModularPort_a
  "Base model for all modular models with multiple inlet ports and one outlet port"

  // Definition of the medium model
  //
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialTwoPhaseMedium
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation (choicesAllMatching = true);

  // Definition of parameters describing modular approach
  //
  parameter Integer nPorts = 1
    "Number of outlet ports"
    annotation(Dialog(group="Modular approach"));

  // Definition of parameters describing assumptions
  //
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions",group="General"), Evaluate=true);

  // Definition of parameters describing initialisation and numeric limits
  //
  parameter Modelica.SIunits.PressureDifference dp_start = 1e5
    "Guess value of pressure difference for subcomponents"
    annotation(Dialog(tab = "Advanced",group="Initialisation medium"));
  parameter Medium.MassFlowRate m_flow_start = 0.5*m_flow_nominal
    "Guess value of m_flow = sum(ports_a.m_flow)"
    annotation(Dialog(tab = "Advanced",group="Initialisation medium"));
  parameter Modelica.SIunits.PressureDifference dp_nominal = 7.5e5
    "Pressure drop at nominal conditions"
    annotation(Dialog(tab = "Advanced",group="Numeric limitations"));
  parameter Medium.MassFlowRate m_flow_nominal = 0.1
    "Nominal mass flow rate"
    annotation(Dialog(tab = "Advanced",group="Numeric limitations"));
  parameter Medium.MassFlowRate m_flow_small = 1e-6*m_flow_nominal
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced",group="Numeric limitations"));

  // Definition of connectors
  //
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts](
    redeclare final package Medium = Medium,
     m_flow(each min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(each start = Medium.h_default))
    "Fluid connectors a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare each final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

end PartialModularPort_a;
