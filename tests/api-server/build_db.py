# Generate canned databases for testing.
#
# Run this script and save its stdout to db.json. This will be the database
# used for the tests. If you change the way this test works, the tests may need
# to be updated.

from itertools import cycle
import json

NUM_PRESENTERS = 2

DAYS = ['day_1', 'day_2', 'day_3', 'day_4']
ROOMS = ['bristol_2', 'great_britain']
SESSIONS = ['session_1', 'session_2']


def make_presenter(id):
    return {
        'bio': 'BIO{}'.format(id),
        'country': 'IRL',
        'name': 'NAME{}'.format(id),
        'id': id,
    }


def make_proposal(id, day, room, session, pid):
    return {
        'day': day,
        'id': id,
        'presenters': [pid],
        'room': room,
        'session': session,
        'summary': 'proposal {} summary'.format(id),
        'title': 'proposal {}'.format(id)
    }


presenters = [make_presenter(id) for id in range(NUM_PRESENTERS)]
slots = ((day, room, session)
         for day in DAYS
         for room in ROOMS
         for session in SESSIONS)
assignments = zip(slots, cycle(range(NUM_PRESENTERS)))
sessions = [make_proposal(id, day, room, session, pid)
             for (id, ((day, room, session), pid))
             in enumerate(assignments)]


conference = {
    'presenters': presenters,
    'sessions': sessions
}

print(json.dumps(conference))
