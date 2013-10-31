pagerduty-sdk
=============

pagerduty-sdk is a Ruby Gem for communicating with the
[Pagerduty](http://www.pagerduty.com) API. It was designed to be as
fully object-oriented as possible. Although it is still under some
construction, it is functional and ready for use. 

I plan to do much more work on this gem, and your feedback is greatly
appreciated!

2013-10-31
=============

I have just pushed my first commit of this gem to Github. I will be
refactoring a lot of the code (and completing the last couple of
functions) as soon as I can. Since I haven't generated any documentation
for the gem, please know that you can pass the parameters as expected by
any of the API methods below to the functions I've listed at the end of
this README. 

Example: If the `get_user` Users API method expects a user id, you would
call the Pagerduty function as follows: `pagerduty.get_user(id:
"#{USERID}")`

This Gem is under construction!

#### Alerts
http://developer.pagerduty.com/documentation/rest/alerts

#### Users
http://developer.pagerduty.com/documentation/rest/users

#### Incidents
http://developer.pagerduty.com/documentation/rest/incidents

#### Escalation Policies
http://developer.pagerduty.com/documentation/rest/escalation_policies

#### Escalation Rules
http://developer.pagerduty.com/documentation/rest/escalation_policies/escalation_rules

#### Log Entries
http://developer.pagerduty.com/documentation/rest/log_entries

#### Maintenance Windows
http://developer.pagerduty.com/documentation/rest/maintenance_windows

#### Reports
http://developer.pagerduty.com/documentation/rest/reports

#### Schedules
http://developer.pagerduty.com/documentation/rest/schedules
- [x] GET schedules	List existing on-call schedules.
- [x] GET schedules/:id	Show detailed information about a schedule, including entries for each layer and sub-schedule.
- [x] GET schedules/:id/users	List all the users on-call in a given schedule for a given time range.
- [ ] POST schedules	Create a new on-call schedule.
- [ ] PUT schedules/:id	Update an existing on-call schedule.
- [ ] POST schedules/preview	Preview the configuration of an on-call schedule.
- [ ] DELETE schedules/:id	Delete an on-call schedule.
- [ ] GET schedules/:id/entries	List schedule entries that are active for a given time range for a specified on-call schedule.

#### Services
http://developer.pagerduty.com/documentation/rest/services
- [x] GET services	List existing services.
- [x] GET services/:id	Get details about an existing service.
- [x] POST services	Create a new service.
- [ ] PUT services/:id	Update an existing service.
- [ ] DELETE services/:id	Delete an existing service. Once the service is deleted, it will not be accessible from the web UI and new incidents won't be able to be created for this service.
- [ ] PUT services/:id/disable	Disable a service. Once a service is disabled, it will not be able to create incidents until it is enabled again.
- [ ] PUT services/:id/enable	Enable a previously disabled service.
- [ ] POST services/:id/regenerate_key	Regenerate a new service key for an existing service.



## Installation

```
gem install pagerduty-sdk
```


## Usage

Example of getting all incidents within the past 24 hours:

```ruby
require 'pagerduty'

pagerduty = Pagerduty.new(token: "#{token}", subdomain: "#{subdomain}")
#<Pagerduty:0x007f9a340fc410>

pagerduty.incidents

[<Pagerduty::Incident
	id=
	incident_number=
	created_on=
	status=
	html_url=
	incident_key=
	service=#<Service:0x007f9a35106dd8 @id="", @name="", @html_url="", @delete_at=nil>
	escalation_policy=#<EscalationPolicy:0x007f9a35105168 @id="", @name="", @description=nil, @escalation_rules=[], @services=#<Set: {}>, @num_loops=nil>
	assigned_to_user=nil
	trigger_summary_data=#<TriggerSummaryData:0x007f9a3510d6d8 @subject="">
	trigger_details_html_url=""
	trigger_type=""
	last_status_change_on=""
	last_status_change_by=#<LastStatusChangeBy:0x007f9a3510c440 @id="", @name="", @email="", @html_url="">
	number_of_escalations=0
	resolved_by_user=#<ResolvedByUser:0x007f9a3511cd90 @id="", @name="", @email="", @html_url="">
>]
```

You can filter the incidents returned by their status (triggered,
acknowledged, resolved) by using the accessor method on the array of
incidents (`pagerduty.incidents.triggered`)

You can acknowledge or resolve an incident easily by calling the
`acknowledge` or `resolve` methods of the `Pagerduty::Incident` object

You can also reassign the incident to another user by calling the
`reassign` method. This method takes accepts a hash with the expected
API parameters which you can see from the Pagerduty documentation link
above. 


Here's a list of other supported functions (until I have the full
documentation up)

```
> pagerduty.interesting_methods
[
    [ 0] :alerts,
    [ 1] :alerts_per_time,
    [ 2] :create_escalation_policy,
    [ 3] :create_maintenance_window,
    [ 4] :create_service,
    [ 5] :create_user,
    [ 6] :curl,
    [ 7] :escalation_policies,
    [ 8] :escalation_rules,
    [ 9] :get_escalation_policy,
    [10] :get_escalation_rule,
    [11] :get_incident,
    [12] :get_incident_counts,
    [13] :get_log_entries,
    [14] :get_log_entry,
    [15] :get_maintenance_window,
    [16] :get_maintenance_windows,
    [17] :get_schedule,
    [18] :get_schedule_users,
    [19] :get_schedules,
    [20] :get_service,
    [21] :get_services,
    [22] :get_user,
    [23] :get_users,
    [24] :has_requirements?,
    [25] :incidents,
    [26] :incidents_per_time,
    [27] :notes,
    [28] :subdomain,
    [29] :token
]
```



