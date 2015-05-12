SELECT timestamp,
CASE event_action WHEN 'click-result' THEN 'clickthroughs'
WHEN 'session-start' THEN 'search sessions'
WHEN 'impression-results' THEN 'Result pages opened' END AS action,
event_clickIndex AS click_index,
event_numberOfResults AS result_count,
event_resultSetType as result_type,
event_timeOffsetSinceStart AS time_offset,
event_timeToDisplayResults AS load_time,
event_platformVersion AS version
FROM MobileWebSearch_12054448
WHERE event_action IN ('click-result','session-start','impression-results');