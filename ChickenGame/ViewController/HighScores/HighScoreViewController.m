//
//  HighScoreViewController.m
//  ChickenGame
//
//  Created by Neeraj Solanki on 27/04/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "HighScoreViewController.h"
#import "HighScoreTableViewCell.h"
@interface HighScoreViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITableView *tableViewObj;

@end

@implementation HighScoreViewController
{
    NSMutableArray *highScoreRecords;
    NSUserDefaults *gameScore;
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gameScore =[NSUserDefaults standardUserDefaults];
    if(gameScore)
    {
        highScoreRecords = [NSMutableArray new];
        highScoreRecords = [[gameScore objectForKey:@"highScores"] mutableCopy];
        if(highScoreRecords==nil)
        {
            highScoreRecords = [NSMutableArray new];
        }
    }
    else
    {
        highScoreRecords = [NSMutableArray new];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HighScoreTableViewCell *cell = (HighScoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HighScoreTableViewCell class])];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HighScoreTableViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSNumber *tmp=[highScoreRecords objectAtIndex:indexPath.row];
    int score =[tmp intValue];
    cell.score.text=[NSString stringWithFormat:@"%d  Scores",score];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return highScoreRecords.count;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
