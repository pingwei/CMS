/**
 * Class Cms_Admin_Navi
 */
function Cms_Admin_Navi() {
  ;
}

/**
 * Toggle navi.
 */
function Cms_Admin_Navi_showNavi() {
  if ($('menu').getStyle('display') != 'block') {
    $('menu').setStyle({'display' : 'block'});
    $('content').setStyle({'display' : 'none'});
  } else {
    $('menu').setStyle({'display' : 'none'});
    $('content').setStyle({'display' : 'block'});
  }
}
Cms_Admin_Navi.showNavi = Cms_Admin_Navi_showNavi;
