/* French initialisation for the jQuery UI date picker plugin. */
/* Written by Keith Wood (kbwood{at}iinet.com.au),
 Stéphane Nahmani (sholby@sholby.net),
 Stéphane Raimbault <stephane.raimbault@gmail.com> */
( function( factory ) {
  if ( typeof define === "function" && define.amd ) {

    // AMD. Register as an anonymous module.
    define( [ "../widgets/datepicker" ], factory );
  } else {

    // Browser globals
    factory( jQuery.datepicker );
  }
}( function( datepicker ) {

  datepicker.regional.fr = {
    closeText: "Fermer",
    prevText: "Précédent",
    nextText: "Suivant",
    currentText: "Aujourd'hui",
    monthNames: [ "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
      "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre" ],
    monthNamesShort: [ "Janv.", "Févr.", "Mars", "Avr.", "Mai", "Juin",
      "Juil.", "Août", "Sept.", "Oct.", "Nov.", "Déc." ],
    dayNames: [ "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" ],
    dayNamesShort: [ "Dim.", "lun.", "Mar.", "Mer.", "Jeu.", "Ven.", "Sam." ],
    dayNamesMin: [ "Di","Lu","Ma","Me","Je","Ve","Sa" ],
    weekHeader: "Sem.",
    dateFormat: "dd/mm/yy",
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: "" };
  datepicker.setDefaults( datepicker.regional.fr );

  return datepicker.regional.fr;

} ) );
