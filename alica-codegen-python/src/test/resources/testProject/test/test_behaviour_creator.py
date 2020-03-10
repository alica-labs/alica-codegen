import unittest
from behaviour_creator import BehaviourCreator
from testfxbehaviour import TestfxBehaviour


class TestStringMethods(unittest.TestCase):
    def test_create_existing_behaviour(self):
        behaviour_creator = BehaviourCreator()
        behaviour = behaviour_creator.create_behaviour(1575724510639)
        self.assertTrue(type(behaviour) == TestfxBehaviour)

    def test_create_not_existing_behaviour(self):
        behaviour_creator = BehaviourCreator()
        with self.assertRaises(ValueError):
            behaviour_creator.create_behaviour(0)


if __name__ == '__main__':
    unittest.main()
