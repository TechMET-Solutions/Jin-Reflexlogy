/* Image w/ description tooltip v2.0
* Created: April 23rd, 2010. This notice must stay intact for usage 
* Author: Dynamic Drive at http://www.dynamicdrive.com/
* Visit http://www.dynamicdrive.com/ for full source code
*/
var ddimgtooltip={

	tiparray:function(){
		var tooltips=[]
		var baseUrl="https://jinreflexology.in/wp-content/uploads/2016/04/";

tooltips[1]=[baseUrl+"1-Brain-Head.jpg", "Brain-Head", {background:"white", font:"bold 18px Arial"}]
tooltips[2]=[baseUrl+"2-Pituitary-Gland-1.jpg", "Pituitary Gland", {background:"white", font:"bold 18px Arial"}]
tooltips[3]=[baseUrl+"3-Throat.jpg", "Throat", {background:"white", font:"bold 18px Arial"}]
tooltips[4]=[baseUrl+"4-Parathyroid.jpg", "Parathyroid Gland", {background:"white", font:"bold 18px Arial"}]
tooltips[6]=[baseUrl+"6-Thyroid-Gland.jpg", "Thyroid", {background:"white", font:"bold 18px Arial"}]
tooltips[7]=[baseUrl+"7-Eesophagus_4.jpg", "Esophagus", {background:"white", font:"bold 18px Arial"}]
tooltips[8]=[baseUrl+"8-Chest_2.jpg", "Chest", {background:"white", font:"bold 18px Arial"}]
tooltips[9]=[baseUrl+"9-Solar-Plexus-1.jpg", "Solar Plexues", {background:"white", font:"bold 18px Arial"}]
tooltips[10]=[baseUrl+"10-Pancreas.jpg", "Pancreas-Gland", {background:"white", font:"bold 18px Arial"}]
tooltips[11]=[baseUrl+"11-Adrenal.jpg", "Adrinal-Gland", {background:"white", font:"bold 18px Arial"}]
tooltips[121]=[baseUrl+"12-Thoracic-Vertebra-T1.jpg", "Throcic T-1", {background:"white", font:"bold 18px Arial"}]
tooltips[122]=[baseUrl+"12-Thoracic-Vertebra-T2.jpg", "Throcic T-2", {background:"white", font:"bold 18px Arial"}]
tooltips[123]=[baseUrl+"12-Thoracic-Vertebra-T3.jpg", "Throcic T-3", {background:"white", font:"bold 18px Arial"}]
tooltips[124]=[baseUrl+"12-Thoracic-Vertebra-T4.jpg", "Throcic T-4", {background:"white", font:"bold 18px Arial"}]
tooltips[125]=[baseUrl+"12-Thoracic-Vertebra-T5.jpg", "Throcic T-5", {background:"white", font:"bold 18px Arial"}]
tooltips[126]=[baseUrl+"12-Thoracic-Vertebra-T6.jpg", "Throcic T-6", {background:"white", font:"bold 18px Arial"}]
tooltips[127]=[baseUrl+"12-Thoracic-Vertebra-T7.jpg", "Throcic T-7", {background:"white", font:"bold 18px Arial"}]
tooltips[128]=[baseUrl+"12-Thoracic-Vertebra-T8.jpg", "Throcic T-8", {background:"white", font:"bold 18px Arial"}]
tooltips[129]=[baseUrl+"12-Thoracic-Vertebra-T9.jpg", "Throcic T-9", {background:"white", font:"bold 18px Arial"}]
tooltips[1210]=[baseUrl+"12-Thoracic-Vertebra-T10.jpg", "Throcic T-10", {background:"white", font:"bold 18px Arial"}]
tooltips[1211]=[baseUrl+"12-Thoracic-Vertebra-T11.jpg", "Throcic T-11", {background:"white", font:"bold 18px Arial"}]
tooltips[1212]=[baseUrl+"12-Thoracic-Vertebra-T12.jpg", "Throcic T-12", {background:"white", font:"bold 18px Arial"}]
tooltips[13]=[baseUrl+"13-Kidney.jpg", "Kidney", {background:"white", font:"bold 18px Arial"}]
tooltips[14]=[baseUrl+"14-Urinery-Tract.jpg", "Urinary Tract", {background:"white", font:"bold 18px Arial"}]
tooltips[151]=[baseUrl+"15-Lumber-L1.jpg", "Lumber L-1", {background:"white", font:"bold 18px Arial"}]
tooltips[152]=[baseUrl+"15-Lumber-L2.jpg", "Lumber L-2", {background:"white", font:"bold 18px Arial"}]
tooltips[153]=[baseUrl+"15-Lumber-L3.jpg", "Lumber L-3", {background:"white", font:"bold 18px Arial"}]
tooltips[154]=[baseUrl+"15-Lumber-L4.jpg", "Lumber L-4", {background:"white", font:"bold 18px Arial"}]
tooltips[155]=[baseUrl+"15-Lumber-L5.jpg", "Lumber L-5", {background:"white", font:"bold 18px Arial"}]
tooltips[16]=[baseUrl+"16-Urinary-Bladder.jpg", "Urinary Bladder", {background:"white", font:"bold 18px Arial"}]
tooltips[17]=[baseUrl+"17-Sacrum.jpg", "Sacrum", {background:"white", font:"bold 18px Arial"}]
tooltips[18]=[baseUrl+"18-Coccyx.jpg", "Coccyx", {background:"white", font:"bold 18px Arial"}]
tooltips[19]=[baseUrl+"19 Internal-Thigh.jpg", "Internal Thigh", {background:"white", font:"bold 18px Arial"}]
tooltips[20]=[baseUrl+"20-Sciatic-nerve.jpg", "Sciatic Nerve", {background:"white", font:"bold 18px Arial"}]
tooltips[21]=[baseUrl+"46-Male-Sex-Organ.jpg", "Sex Organ", {background:"white", font:"bold 18px Arial"}]
tooltips[22]=[baseUrl+"22-Foot-Heel.jpg", "Foot-Heel", {background:"white", font:"bold 18px Arial"}]
tooltips[23]=[baseUrl+"23-Anus.jpg", "Anus", {background:"white", font:"bold 18px Arial"}]
tooltips[24]=[baseUrl+"24-Nose.jpg", "Nose", {background:"white", font:"bold 18px Arial"}]
tooltips[25]=[baseUrl+"25-Eye.jpg", "Eye", {background:"white", font:"bold 18px Arial"}]
tooltips[26]=[baseUrl+"26-Thymus-Gland.jpg", "Thymus", {background:"white", font:"bold 18px Arial"}]
tooltips[27]=[baseUrl+"27-Ear.jpg", "Ear", {background:"white", font:"bold 18px Arial"}]
tooltips[28]=[baseUrl+"28-Lung.jpg", "Lung", {background:"white", font:"bold 18px Arial"}]
tooltips[29]=[baseUrl+"29-shoulder.jpg", "Shoulder", {background:"white", font:"bold 18px Arial"}]
tooltips[30]=[baseUrl+"30-Heart.jpg", "Heart", {background:"white", font:"bold 18px Arial"}]
tooltips[31]=[baseUrl+"31-Stomach.jpg", "Stomach", {background:"white", font:"bold 18px Arial"}]
tooltips[32]=[baseUrl+"32-Elbow.jpg", "Elbow", {background:"white", font:"bold 18px Arial"}]
tooltips[33]=[baseUrl+"33-Wrist.jpg", "Wrist-Hand", {background:"white", font:"bold 18px Arial"}]
tooltips[34]=[baseUrl+"34-Leg-Foot.jpg", "Leg", {background:"white", font:"bold 18px Arial"}]
tooltips[35]=[baseUrl+"35-Knee.jpg", "Knee", {background:"white", font:"bold 18px Arial"}]
tooltips[36]=[baseUrl+"36-Thigh.jpg", "Knee", {background:"white", font:"bold 18px Arial"}]

tooltips[38]=[baseUrl+"38-Appendix.jpg", "Appendix", {background:"white", font:"bold 18px Arial"}]
tooltips[39]=[baseUrl+"39-Gallbladder.jpg", "Gallbladder", {background:"white", font:"bold 18px Arial"}]
tooltips[40]=[baseUrl+"40-liver.jpg", "Liver", {background:"white", font:"bold 18px Arial"}]
tooltips[41]=[baseUrl+"41-Duodinum.jpg", "Duodinum", {background:"white", font:"bold 18px Arial"}]
tooltips[42]=[baseUrl+"42-Large-Intestine.jpg","Large Intestine",{background:"white", font:"bold 18px Arial"}]
tooltips[43]=[baseUrl+"43-Small-Intestine.jpg", "Small Intestine", {background:"white", font:"bold 18px Arial"}]
tooltips[44]=[baseUrl+"44-Tongue-1.jpg", "Tongue", {background:"white", font:"bold 18px Arial"}]
tooltips[45]=[baseUrl+"45-Spleen.jpg", "Spleen", {background:"white", font:"bold 18px Arial"}]
tooltips[47]=[baseUrl+"47-Female-Sex-Organ.jpg", "Female Sex Organ", {background:"white", font:"bold 18px Arial"}]
tooltips[48]=[baseUrl+"48-Rectum.jpg", "Rectum", {background:"white", font:"bold 18px Arial"}]

tooltips[51]=[baseUrl+"5-Cervical-C1_5.jpg", "Cervical C-1", {background:"white", font:"bold 18px Arial"}]

tooltips[52]=[baseUrl+"5-Cervical-C2-1.jpg", "Cervical C-2", {background:"white", font:"bold 18px Arial"}]
tooltips[53]=[baseUrl+"5-Cervical-C3-1.jpg", "Cervical C-3", {background:"white", font:"bold 18px Arial"}]
tooltips[54]=[baseUrl+"5-Cervical-C4-1.jpg", "Cervical C-4", {background:"white", font:"bold 18px Arial"}]
tooltips[55]=[baseUrl+"5-Cervical-C5-1.jpg", "Cervical C-5", {background:"white", font:"bold 18px Arial"}]
tooltips[56]=[baseUrl+"5-Cervical-C6-1.jpg", "Cervical C-6", {background:"white", font:"bold 18px Arial"}]
tooltips[57]=[baseUrl+"5-Cervical-C7-1.jpg", "Cervical C-7", {background:"white", font:"bold 18px Arial"}]


return tooltips //do not remove/change this line
	}(),

	tooltipoffsets: [20, -30], //additional x and y offset from mouse cursor for tooltips

	//***** NO NEED TO EDIT BEYOND HERE

	tipprefix: 'imgtip', //tooltip ID prefixes

	createtip:function($, tipid, tipinfo){
		if ($('#'+tipid).length==0){ //if this tooltip doesn't exist yet
			return $('<div id="' + tipid + '" class="ddimgtooltip" />').html(
				'<div style="text-align:center"><img src="' + tipinfo[0] + '"> </div>'
				+ ((tipinfo[1])? '<div style="text-align:left; margin-top:5px";>'+tipinfo[1]+'</div>' : '')
				)
			.css(tipinfo[2] || {})
			.appendTo(document.body)
		}
		return null
	},

	positiontooltip:function($, $tooltip, e){
		var x=e.pageX+this.tooltipoffsets[0], y=e.pageY+this.tooltipoffsets[1]
		var tipw=$tooltip.outerWidth(), tiph=$tooltip.outerHeight(), 
		x=(x+tipw>$(document).scrollLeft()+$(window).width())? x-tipw-(ddimgtooltip.tooltipoffsets[0]*2) : x
		y=(y+tiph>$(document).scrollTop()+$(window).height())? $(document).scrollTop()+$(window).height()-tiph-10 : y
		$tooltip.css({left:x, top:y})
	},
	
	showbox:function($, $tooltip, e){
		$tooltip.show()
		this.positiontooltip($, $tooltip, e)
	},

	hidebox:function($, $tooltip){
		$tooltip.hide()
	},


	init:function(targetselector){
		jQuery(document).ready(function($){
			var tiparray=ddimgtooltip.tiparray
			var $targets=$(targetselector)
			if ($targets.length==0)
				return
			var tipids=[]
			$targets.each(function(){
				var $target=$(this)
				$target.attr('rel').match(/\[(\d+)\]/) //match d of attribute rel="imgtip[d]"
				var tipsuffix=parseInt(RegExp.$1) //get d as integer
				var tipid=this._tipid=ddimgtooltip.tipprefix+tipsuffix //construct this tip's ID value and remember it
				var $tooltip=ddimgtooltip.createtip($, tipid, tiparray[tipsuffix])
				$target.mouseenter(function(e){
					var $tooltip=$("#"+this._tipid)
					ddimgtooltip.showbox($, $tooltip, e)
				})
				$target.mouseleave(function(e){
					var $tooltip=$("#"+this._tipid)
					ddimgtooltip.hidebox($, $tooltip)
				})
				$target.mousemove(function(e){
					var $tooltip=$("#"+this._tipid)
					ddimgtooltip.positiontooltip($, $tooltip, e)
				})
				if ($tooltip){ //add mouseenter to this tooltip (only if event hasn't already been added)
					$tooltip.mouseenter(function(){
						ddimgtooltip.hidebox($, $(this))
					})
				}
			})

		}) //end dom ready
	}
}

//ddimgtooltip.init("targetElementSelector")
ddimgtooltip.init("*[rel^=imgtip]")