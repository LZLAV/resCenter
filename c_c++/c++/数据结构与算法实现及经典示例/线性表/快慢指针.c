class List
{
    public:
        ListNode* InLisNodet(ListNode *head)
        {
            if (!head || !head->next) 
                return head;
            ListNode *low = head, *fast = head;
            while(fast && fast->next)
            {
                low = low->next;
                fast = fast->next->next;
            }
            return low;
        }
};