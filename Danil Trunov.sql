-- 1. Horizontal view
CREATE VIEW gym.v_members_horizontal AS
SELECT id, first_name, last_name, email
FROM gym.members;

SELECT * FROM gym.v_members_horizontal;

-- 2. Vertical view
CREATE VIEW gym.v_member_vertical AS
SELECT 'First name' AS field, first_name AS value FROM gym.members WHERE id = 1
UNION
SELECT 'Last name', last_name FROM gym.members WHERE id = 1
UNION
SELECT 'Email', email FROM gym.members WHERE id = 1;

SELECT * FROM gym.v_member_vertical;

-- 3. Mixed view
CREATE VIEW gym.v_mixed_member_info AS
SELECT m.id, m.first_name, m.last_name, COUNT(p.id) AS photo_count, COUNT(n.id) AS notification_count
FROM gym.members m
LEFT JOIN gym.member_photos p ON p.member_id = m.id
LEFT JOIN gym.notifications n ON n.member_id = m.id
GROUP BY m.id;

SELECT * FROM gym.v_mixed_member_info;

-- 4. View with join
CREATE VIEW gym.v_membership_details AS
SELECT m.id AS member_id, m.first_name, m.last_name,
       ms.name AS status, st.name AS subscription_type
FROM gym.members m
JOIN gym.memberships mb ON mb.member_id = m.id
JOIN gym.membership_statuses ms ON ms.id = mb.status_id
JOIN gym.subscription_types st ON st.id = mb.subscription_type_id;

SELECT * FROM gym.v_membership_details;

-- 5. View with subquery
CREATE VIEW gym.v_active_members_with_photo_count AS
SELECT m.id, m.first_name, m.last_name,
       (SELECT COUNT(*) FROM gym.member_photos p WHERE p.member_id = m.id) AS photo_count
FROM gym.members m
WHERE EXISTS (
    SELECT 1 FROM gym.memberships mb
    WHERE mb.member_id = m.id
    AND mb.status_id = 2
);

SELECT * FROM gym.v_active_members_with_photo_count;

-- 6. View with union
CREATE VIEW gym.v_all_notifications_and_feedback AS
SELECT member_id, message AS info, sent_at AS date
FROM gym.notifications
UNION
SELECT member_id, notes AS info, created_at AS date
FROM gym.feedback_equipment;

SELECT * FROM gym.v_all_notifications_and_feedback;

-- 7. View on another view
CREATE VIEW gym.v_members_basic_info AS
SELECT id, first_name, last_name FROM gym.members;

CREATE VIEW gym.v_uppercase_names AS
SELECT UPPER(first_name) AS first_name_upper, UPPER(last_name) AS last_name_upper
FROM gym.v_members_basic_info;

SELECT * FROM gym.v_uppercase_names;

-- 8. View with CHECK OPTION
CREATE VIEW gym.v_verified_profiles AS
SELECT * FROM gym.member_photos
WHERE is_profile_photo = TRUE
WITH CHECK OPTION;

SELECT * FROM gym.v_verified_profiles;
