// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	// Fetching all topics
	getTopics: function (component) {
		this.debug(component, "Fetch topics Called..", null);
		var action = component.get("c.getTopics");

		action.setCallback(this, function (response) {

			var values = response.getReturnValue();
			var valuesTemp = [];
			for (var value in values) {
				if (values.hasOwnProperty(value)) {
					valuesTemp.push({
						key: value,
						value: values[value]
					});
				}
			}

			component.set("v.values", valuesTemp);

		});
		$A.enqueueAction(action);
	},
	// dropdown initialize method for topics
	initializeDropdown: function (component) {
		try {
			$(".topic")
				.addClass("ui fluid search")
				.dropdown({
					placeholder: "Select Topics",
					onRemove: function (removedValue, removedText) {

					}
				});


		} catch (e) {
			this.debug(component, null, e);
		}
	},
	//Method to close and open the dropdown menus
	setupDropdown: function (component) {
		$('#dropDwnBtn').click(function (ev) {
			ev.stopPropagation();
			if ($('#dropDwnBtn_menu:visible').length > 0) {
				$('#dropDwnBtn_menu').hide();
			} else {
				$('#dropDwnBtn_menu').show();
			}
		});
		$(window).click(function () {
			$('#dropDwnBtn_menu').hide();
		});
	}
})