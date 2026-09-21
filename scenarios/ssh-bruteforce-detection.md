# Scenario: Detecting SSH Brute Force Attempts

## Setup
- Attacker VM on isolated VLAN attempts repeated SSH logins against a target host
- Suricata monitoring the target's VLAN segment

## Detection
Suricata rule triggers after 5 failed attempts within 60 seconds (see `/ids/suricata_rules_sample.rules`)

## Response
1. Alert reviewed in Suricata log
2. Source IP blocked at firewall
3. Incident logged with timestamp and source

## Lessons
Demonstrates basic IDS tuning and incident response workflow in a controlled environment.
