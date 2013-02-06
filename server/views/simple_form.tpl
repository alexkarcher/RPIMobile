<html>
	<head>
		<title>
			Edit building hours
		</title>
		<script src='http://code.jquery.com/jquery-1.8.2.min.js'></script>
		<script>
			// Sending to the server the recorded values
			function save(index){
				params = {
							"id": $('#field' + index + 'id').val(),
							"name": $('#field' + index + 'name').val(),
							"sunday": $('#field' + index + 'day0').attr('checked'),
							"monday": $('#field' + index + 'day1').attr('checked'),
							"tuesday": $('#field' + index + 'day2').attr('checked'),
							"wednesday": $('#field' + index + 'day3').attr('checked'),
							"thursday": $('#field' + index + 'day4').attr('checked'),
							"friday": $('#field' + index + 'day5').attr('checked'),
							"saturday": $('#field' + index + 'day6').attr('checked'),
							"openhour": $('#field' + index + 'openhour').val(),
							"closehour": $('#field' + index + 'closehour').val(),
						}
				$.post(
					'/v1/building_hours/save',
					data=params,
					success=function(){
										alert('Saved');
										window.location = window.location;
										}
				);
			}
			
			function delete_row(index){
				params = {
					"id": $('#field' + index + 'id').val()
				}
				var sure_confirm = confirm("Are you sure you want to delete?");
				
				if (!sure_confirm){
					return;
				}
				
				$.post(
					'/v1/building_hours/delete',
					data=params,
					success=function(){
										alert('Deleted'); 
										window.location = window.location;
										}
				);
			}
		</script>
	</head>
	<body>
		<p>{{description}}</p>
		<table border='1px'>
			%for index, field in enumerate(form_fields):
			<tr id='field{{index}}'>
				<input type='hidden' id='field{{index}}id' value='{{field._id}}' />
				<td>
					<input id='field{{index}}name' type='text' value='{{field._name}}' />
				</td>
					<!-- First letter in day -->
					%for daynum, day in enumerate(days):
						<td>{{days[day][0].upper()}}<input type='checkbox' id='field{{index}}day{{day}}' /></td>
						%if field._days[daynum] == 1:
							<script>$('#field{{index}}day{{day}}').attr('checked',true);</script>
						%end
					%end
				<td>Opens: <input id='field{{index}}openhour' type='text' value='{{field._opentime}}' /></td>
				<td>Closes: <input id='field{{index}}closehour' type='text' value='{{field._closetime}}' /></td>
				<td><input type='button' onclick='save({{index}})' value='Save' /></td>
				<td><input type='button' onclick='delete_row({{index}})' value='Delete' /></td>
			</tr>
			%end
		</table>
	</body>
</html>
