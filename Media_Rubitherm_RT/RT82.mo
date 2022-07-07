﻿within slPCMlib.Media_Rubitherm_RT;
package RT82 "Rubitherm RT82; data taken from: data_sheet; last access: 01.12.2019."
   extends  slPCMlib.Interfaces.partialPCM;

  // ----------------------------------
  redeclare replaceable record propData "PCM record"

    constant String mediumName = "RT82";

    // --- parameters for phase transition functions ---
    constant Boolean modelForMelting =        true;
    constant Boolean modelForSolidification = false;
    constant Modelica.Units.SI.Temperature rangeTmelting[2] =  {3.431500000000000e+02, 3.571500000000000e+02}
             "temperature range melting {startT, endT}";
    constant Modelica.Units.SI.Temperature rangeTsolidification[2] = {3.431500000000000e+02, 3.571500000000000e+02}
             "temperature range solidification {startT, endT}";

    // --- parameters for heat capacity and enthalpy ---
    constant Modelica.Units.SI.SpecificHeatCapacity[2] cpS_linCoef = {2.000000000000000e+03, 0.0}
             "solid specific heat capacity, linear coefficients a + b*T";
    constant Modelica.Units.SI.SpecificHeatCapacity[2] cpL_linCoef = {2.000000000000000e+03, 0.0}
             "liquid specific heat capacity, linear coefficients a + b*T";
    constant Modelica.Units.SI.SpecificEnthalpy   phTrEnth = 9.119378815519909e+04
             "scalar phase transition enthalpy";

    // --- reference values ---
    constant Modelica.Units.SI.Temperature            Tref = 273.15+25
             "reference temperature";
    constant Modelica.Units.SI.SpecificEnthalpy  href = 0.0
             "reference enthalpy at Tref";

  end propData;
  // ----------------------------------
  redeclare function extends phaseFrac_complMelting
    "Returns liquid mass phase fraction for complete melting processes"
  protected
    constant Integer pieces =   data_H.pieces;
    constant Integer order[:] = data_H.order;
    constant Real breaks[:] =   data_H.breaks;
    constant Real coefs[:,:] =  data_H.coefs;
  algorithm
    (xi, dxi) := BasicUtilities.quartQuintSplineEval(T-273.15,
                 pieces, order, breaks, coefs[:,:]);
  end phaseFrac_complMelting;
  // ----------------------------------
  redeclare function extends phaseFrac_complSolidification
    "Returns liquid mass phase fraction for complete solidification processes"
  protected
    constant Integer pieces =   data_C.pieces;
    constant Integer order[:] = data_C.order;
    constant Real breaks[:] =   data_C.breaks;
    constant Real coefs[:,:] =  data_C.coefs;
  algorithm
    (xi, dxi) := BasicUtilities.quartQuintSplineEval(T-273.15,
                     pieces, order, breaks, coefs[:,:]);
  end phaseFrac_complSolidification;

  // ----------------------------------
  package data_H "spline interpolation data for heating"
    extends Modelica.Icons.Package;
    constant Integer pieces =  16;
    constant Integer[16] order =  {1, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 5, 6, 1};
    constant Real[17] breaks = {-3.000000000000000e+01, 7.000000000000000e+01, 7.100000000000000e+01, 7.200000000000000e+01, 7.300000000000000e+01, 7.400000000000000e+01, 7.500000000000000e+01, 7.600000000000000e+01, 7.700000000000000e+01, 7.800000000000000e+01, 7.900000000000000e+01, 8.000000000000000e+01, 8.100000000000000e+01, 8.200000000000000e+01, 8.300000000000000e+01, 8.400000000000000e+01, 1.840000000000000e+02};
    constant Real[16,7] coefs = { {0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00},  {0.000000000000000e+00, -9.804508148166869e-16, -2.150257895084031e-17, 1.385114730357407e-18, -2.891205793294678e-19, 1.095131183327149e-03, -3.597152042307760e-04},  {7.354159790953722e-04, 3.317364691250252e-03, 5.555583769809836e-03, 3.757007748655970e-03, 7.992785317410509e-05, -2.902311188423046e-05, 0.000000000000000e+00},  {1.341627693010130e-02, 2.587415133011145e-02, 1.701594301598003e-02, 3.786488042510086e-03, -6.518770624704721e-05, -4.545580041335044e-04, 0.000000000000000e+00},  {5.957311360832231e-02, 6.873196064394541e-02, 2.343870086469295e-02, -1.019842823813145e-03, -2.337977726914570e-03, 1.249749248007138e-03, 0.000000000000000e+00},  {1.496357038142401e-01, 1.094466692342707e-01, 1.884879851183750e-02, 2.125738748599951e-03, 3.910768513121120e-03, -1.221762082613523e-03, 0.000000000000000e+00},  {2.827459167394558e-01, 1.630557461431630e-01, 3.647300501022887e-02, 5.551191974949203e-03, -2.198041899946494e-03, 3.831735789377329e-04, 0.000000000000000e+00},  {4.860109915467881e-01, 2.457790323833692e-01, 4.377006532477480e-02, 5.907601645405562e-04, -2.821740052578295e-04, 1.875312707973040e-04, 0.000000000000000e+00},  {7.760562066850121e-01, 3.349004038594958e-01, 4.572461449482253e-02, 1.337376851482277e-03, 6.554823487286902e-04, -3.145484543016859e-05, 0.000000000000000e+00},  {1.158642629394111e+00, 4.328264185713499e-01, 5.335509068733978e-02, 3.644757792095351e-03, 4.982081215778473e-04, -5.881382317582048e-04, 0.000000000000000e+00},  {1.648378966334716e+00, 5.495230146498364e-01, 6.139723047551088e-02, -2.437920391753074e-04, -2.442483037213177e-03, 1.250328843225803e-03, 0.000000000000000e+00},  {2.257863265226900e+00, 6.680678115506079e-01, 5.851424456696391e-02, 2.489564244230014e-03, 3.809161178915836e-03, -1.647410299181844e-03, 0.000000000000000e+00},  {2.989096636468436e+00, 7.995645866369822e-01, 7.236380138133058e-02, 1.252105968074934e-03, -4.427890316993381e-03, -3.943889627162881e-03, 2.137987519873550e-03},  {3.856043338030541e+00, 9.234454230193275e-01, 4.218369391006967e-02, -1.313860117405640e-02, 7.922474345295463e-03, -2.868405170521893e-03, 0.000000000000000e+00},  {4.813587922960656e+00, 9.857448788458674e-01, 2.161868475445427e-02, -1.013275549809347e-02, -6.419551507314001e-03, 8.175467855279245e-03, -2.297185851272148e-03},  {5.810277461559576e+00, 1.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00}};
  end data_H;
  // ----------------------------------
  package data_C "spline interpolation data for cooling"
    extends Modelica.Icons.Package;
    constant Integer pieces =  16;
    constant Integer[16] order =  {1, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 5, 6, 1};
    constant Real[17] breaks = {-3.000000000000000e+01, 7.000000000000000e+01, 7.100000000000000e+01, 7.200000000000000e+01, 7.300000000000000e+01, 7.400000000000000e+01, 7.500000000000000e+01, 7.600000000000000e+01, 7.700000000000000e+01, 7.800000000000000e+01, 7.900000000000000e+01, 8.000000000000000e+01, 8.100000000000000e+01, 8.200000000000000e+01, 8.300000000000000e+01, 8.400000000000000e+01, 1.840000000000000e+02};
    constant Real[16,7] coefs = { {0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00},  {0.000000000000000e+00, 1.398647497037470e-14, 2.465667816756053e-16, -2.388171747850628e-19, 1.445602896647339e-19, 6.377667925411409e-04, -8.624892803132197e-05},  {5.515178645240519e-04, 2.671340394533027e-03, 5.083934004941839e-03, 4.652689364784969e-03, 1.895100042235875e-03, -9.745093695659066e-04, 0.000000000000000e+00},  {1.388007230145386e-02, 2.950512981988756e-02, 2.066750865705297e-02, 2.487995838069404e-03, -2.977446805593658e-03, 6.067653329278029e-04, 0.000000000000000e+00},  {6.417002514379792e-02, 6.942817409046700e-02, 1.633446866697727e-02, -3.354138055027195e-03, 5.637985904535676e-05, 1.021669457489893e-03, 0.000000000000000e+00},  {1.476565791627502e-01, 9.736856398297475e-02, 1.682702823106683e-02, 7.088075956053164e-03, 5.164727146494823e-03, -2.596490611810101e-03, 0.000000000000000e+00},  {2.715084838675297e-01, 1.599633038402128e-01, 4.311471286009454e-02, 1.782078423931449e-03, -7.817725912555680e-03, 2.775737268004817e-03, 0.000000000000000e+00},  {4.713265903472176e-01, 2.341467475219943e-01, 2.931196533660292e-02, -1.731452546243105e-03, 6.060960427468402e-03, -1.482223151818378e-03, 0.000000000000000e+00},  {7.376325879352219e-01, 3.044090465072460e-01, 4.566113874450013e-02, 7.690157645446727e-03, -1.350155331623486e-03, -3.000893929397265e-04, 0.000000000000000e+00},  {1.093742686107851e+00, 4.119007286413933e-01, 5.762978576170212e-02, -7.113576104444830e-04, -2.850602296322119e-03, 1.105471653885118e-03, 0.000000000000000e+00},  {1.560816712258065e+00, 5.191511764176026e-01, 4.944681569128716e-02, -1.059050256881776e-03, 2.676755973103472e-03, -6.023503996194302e-04, 0.000000000000000e+00},  {2.130430059683557e+00, 6.225629289238462e-01, 5.630669676306832e-02, 3.624469639337812e-03, -3.349960249936781e-04, -1.688152445223388e-04, 0.000000000000000e+00},  {2.812420343740293e+00, 7.438656710454143e-01, 6.348197708589638e-02, 5.963330941397123e-04, -1.179072247605372e-03, 2.963832157103957e-04, -3.373649837859843e-05},  {3.619447899435471e+00, 8.691818325974843e-01, 6.065432756410826e-02, -1.830853706749788e-03, -2.032036447323701e-04, -1.659127950073774e-03, 0.000000000000000e+00},  {4.545590874295507e+00, 9.758894722761475e-01, 3.735126507472684e-02, -1.923494778641701e-02, -8.498843395101241e-03, 1.256955905200609e-02, -3.623263457661949e-03},  {5.540044116059207e+00, 1.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00, 0.000000000000000e+00}};
  end data_C;
  // ----------------------------------
  redeclare function extends density_solid "Returns solid density"
  algorithm
    rho := 8.800000000000000e+02;
  end density_solid;
  // ----------------------------------
  redeclare function extends density_liquid "Returns liquid density"
  algorithm
    rho := 7.700000000000000e+02;
  end density_liquid;
  // ----------------------------------
  redeclare function extends conductivity_solid "Returns solid thermal conductivity"
  algorithm
    lambda := 2.000000000000000e-01;
  end conductivity_solid;
  // ----------------------------------
  redeclare function extends conductivity_liquid "Returns liquid thermal conductivity"
  algorithm
    lambda := 2.000000000000000e-01;
  end conductivity_liquid;
  // ----------------------------------

annotation(Documentation(
  info="<html>
  <p>
  This package contains solid and liquid properties for the PCM:  <strong>Rubitherm RT82</strong>.<br><br>
  Information taken from: data_sheet - last access 01.12.2019.<br><br>
  It also contains the phase transition functions for
  <ul>
  <li>complete melting       :  true</li>
  <li>complete solidification:  false</li>
  </ul></p><p>
  These functions are modelled by piece-wise splines using <strong>variable order quartic and quintic</strong> method,
  see also 
  <blockquote>
  <p>
  Barz, T., Krämer, J., & Emhofer, J. (2020). Identification of Phase
  Fraction–Temperature Curves from Heat Capacity Data for Numerical
  Modeling of Heat Transfer in Commercial Paraffin Waxes.
  Energies, 13(19), 5149.
  <a href>doi.org/10.3390/en13195149</a>.
  </p>
  </blockquote>
  </p></html>",
  revisions="<html>
  <ul>
  <li>file creation date: 07-Jul-2022  </ul>
  </html>"));
end RT82;
