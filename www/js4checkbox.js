/* This particular code by 'Dart' and Victor Perrier is available under CC-BY-SA 3.0
 * checkboxGroupInput - set minimum and maximum number of selections - ticks
 * https://stackoverflow.com/questions/31139791/checkboxgroupinput-set-minimum-and-maximum-number-of-selections-ticks
 * originally: Restricting user to check checkbox in jQuery
 * https://stackoverflow.com/questions/18699839/restricting-user-to-check-checkbox-in-jquery/18700246
 */
$( document ).ready( function() {
  $( 'input[name=sister_search_traffic_split]' ).on( 'click', function( event ) {
    if ( $('input[name=sister_search_traffic_split]:checked' ).length > 2 ) {
      $( this ).prop( 'checked', false );
    }
  } );
} );
