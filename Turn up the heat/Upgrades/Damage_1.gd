extends Upgrade

func OnTake():
	for Child in ChildUpgrades:
		Child.reparent(get_parent())
