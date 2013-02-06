import abc

class Row():
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def getInsertQuery(self):
        return

