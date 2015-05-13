SELECT timestamp,
CASE event_action WHEN 'click' THEN 'clickthroughs'
WHEN 'start' THEN 'search sessions'
WHEN 'results' THEN 'Result pages opened' END AS action,
event_timeToDisplayResults AS
load_time FROM MobileWikiAppSearch_10641988
WHERE event_action IN ('click','start','results');