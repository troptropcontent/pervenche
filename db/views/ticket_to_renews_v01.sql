SELECT
unnested_automated_tickets.id as automated_ticket_id,
unnested_automated_tickets.zipcode,
unnested_automated_tickets.last_activated_at,
last_ticket_ends_on_dates.last_ticket_ends_on,
CASE
  WHEN last_ticket_ends_on_dates.last_ticket_ends_on IS NULL or last_ticket_ends_on_dates.last_ticket_ends_on < unnested_automated_tickets.last_activated_at
      THEN unnested_automated_tickets.last_activated_at
      ELSE last_ticket_ends_on_dates.last_ticket_ends_on
END as uncovered_since
FROM (
  SELECT id, active, status, license_plate, UNNEST(zipcodes) as zipcode, last_activated_at
  FROM automated_tickets
  WHERE active = true AND status = 2
) as unnested_automated_tickets
LEFT OUTER JOIN tickets ON tickets.automated_ticket_id = unnested_automated_tickets.id AND tickets.ends_on >= NOW() AND tickets.zipcode = unnested_automated_tickets.zipcode
LEFT OUTER JOIN (
  SELECT automated_ticket_id, zipcode, MAX(ends_on) as last_ticket_ends_on
  FROM tickets
  GROUP BY automated_ticket_id, zipcode
) as last_ticket_ends_on_dates ON last_ticket_ends_on_dates.automated_ticket_id = unnested_automated_tickets.id AND last_ticket_ends_on_dates.zipcode = unnested_automated_tickets.zipcode
WHERE tickets.id IS NULL 